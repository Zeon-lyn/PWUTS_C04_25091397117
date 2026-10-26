<?php
declare(strict_types=1);
require_once __DIR__ . '/config.php';

/*
 * Versi tugas/demo: mengakses penghuni ID 3 (Andi Pratama) dari database contoh.
 * Untuk aplikasi nyata, ID penghuni harus diambil dari sesi login yang tervalidasi.
 */
const DEMO_RESIDENT_ID = 3;

function statusLabel(string $status): string
{
    return match ($status) {
        'diproses' => 'Sedang Diproses',
        'selesai' => 'Selesai',
        default => 'Menunggu Tanggapan',
    };
}

function getComplaintRows(PDO $pdo): array
{
    $sql = "SELECT DISTINCT k.id_keluhan, k.judul_keluhan, k.isi_keluhan,
                   k.kategori_keluhan, k.foto_pendukung, k.tanggal_keluhan,
                   k.tanggapan_owner, k.status_keluhan,
                   p.nama_penghuni, kamar.nomor_kamar
            FROM keluhan k
            INNER JOIN penghuni p ON p.id_penghuni = k.id_penghuni
            LEFT JOIN kamar ON kamar.id_kamar = p.id_kamar
            WHERE k.id_penghuni = :resident_id
            ORDER BY k.tanggal_keluhan DESC, k.id_keluhan DESC";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['resident_id' => DEMO_RESIDENT_ID]);
    $rows = $stmt->fetchAll();

    return array_map(static function (array $row): array {
        return [
            'id' => 'KL-' . str_pad((string)$row['id_keluhan'], 4, '0', STR_PAD_LEFT),
            'id_keluhan' => (int)$row['id_keluhan'],
            'name' => $row['nama_penghuni'],
            'room' => $row['nomor_kamar'] ?? 'Belum ditentukan',
            'date' => $row['tanggal_keluhan'],
            'category' => $row['kategori_keluhan'] ?: 'Lainnya',
            'title' => $row['judul_keluhan'],
            'description' => $row['isi_keluhan'],
            'status' => statusLabel($row['status_keluhan']),
            'response' => $row['tanggapan_owner'] ?? '',
            'photo' => $row['foto_pendukung'] ?? '',
        ];
    }, $rows);
}

try {
    $pdo = db();

    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $resident = $pdo->prepare(
            "SELECT p.nama_penghuni, p.nomor_hp, kamar.nomor_kamar
             FROM penghuni p
             LEFT JOIN kamar ON kamar.id_kamar = p.id_kamar
             WHERE p.id_penghuni = :id AND p.status_penghuni = 'aktif'
             LIMIT 1"
        );
        $resident->execute(['id' => DEMO_RESIDENT_ID]);
        $user = $resident->fetch();

        if (!$user) {
            jsonResponse(['success' => false, 'message' => 'Data penghuni demo tidak ditemukan atau tidak aktif.'], 404);
        }

        jsonResponse([
            'success' => true,
            'user' => [
                'name' => $user['nama_penghuni'],
                'room' => $user['nomor_kamar'] ?? 'Belum ditentukan',
                'phone' => $user['nomor_hp'] ?? '',
            ],
            'data' => getComplaintRows($pdo),
        ]);
    }

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Allow: GET, POST');
        jsonResponse(['success' => false, 'message' => 'Metode request tidak didukung.'], 405);
    }

    $category = trim((string)($_POST['category'] ?? ''));
    $title = trim((string)($_POST['title'] ?? ''));
    $description = trim((string)($_POST['description'] ?? ''));
    $date = trim((string)($_POST['date'] ?? date('Y-m-d')));
    $allowedCategories = ['Fasilitas kamar', 'Air dan sanitasi', 'Listrik', 'Kebersihan', 'Keamanan', 'Lainnya'];

    if (!in_array($category, $allowedCategories, true)) {
        jsonResponse(['success' => false, 'message' => 'Kategori keluhan tidak valid.'], 422);
    }
    if ($title === '' || mb_strlen($title) > 150) {
        jsonResponse(['success' => false, 'message' => 'Judul wajib diisi dan maksimal 150 karakter.'], 422);
    }
    if (mb_strlen($description) < 10) {
        jsonResponse(['success' => false, 'message' => 'Deskripsi minimal 10 karakter.'], 422);
    }
    $dateObject = DateTime::createFromFormat('!Y-m-d', $date);
    if (!$dateObject || $dateObject->format('Y-m-d') !== $date) {
        jsonResponse(['success' => false, 'message' => 'Tanggal pengajuan tidak valid.'], 422);
    }

    $photoPath = null;
    if (isset($_FILES['photo']) && $_FILES['photo']['error'] !== UPLOAD_ERR_NO_FILE) {
        $file = $_FILES['photo'];
        if ($file['error'] !== UPLOAD_ERR_OK) {
            jsonResponse(['success' => false, 'message' => 'Foto gagal diunggah.'], 422);
        }
        if ($file['size'] > 2 * 1024 * 1024) {
            jsonResponse(['success' => false, 'message' => 'Ukuran foto maksimal 2 MB.'], 422);
        }
        $finfo = new finfo(FILEINFO_MIME_TYPE);
        $mime = $finfo->file($file['tmp_name']);
        $extensions = ['image/jpeg' => 'jpg', 'image/png' => 'png'];
        if (!isset($extensions[$mime])) {
            jsonResponse(['success' => false, 'message' => 'Foto harus berformat JPG, JPEG, atau PNG.'], 422);
        }

        $uploadDir = dirname(__DIR__) . '/uploads/keluhan';
        if (!is_dir($uploadDir) && !mkdir($uploadDir, 0775, true) && !is_dir($uploadDir)) {
            jsonResponse(['success' => false, 'message' => 'Folder unggahan tidak dapat dibuat.'], 500);
        }
        $fileName = bin2hex(random_bytes(12)) . '.' . $extensions[$mime];
        if (!move_uploaded_file($file['tmp_name'], $uploadDir . '/' . $fileName)) {
            jsonResponse(['success' => false, 'message' => 'Foto tidak dapat disimpan di server.'], 500);
        }
        $photoPath = 'uploads/keluhan/' . $fileName;
    }

    $stmt = $pdo->prepare(
        "INSERT INTO keluhan
         (id_penghuni, judul_keluhan, isi_keluhan, kategori_keluhan, foto_pendukung, tanggal_keluhan, status_keluhan)
         VALUES (:resident_id, :title, :description, :category, :photo, :date, 'menunggu')"
    );
    $stmt->execute([
        'resident_id' => DEMO_RESIDENT_ID,
        'title' => $title,
        'description' => $description,
        'category' => $category,
        'photo' => $photoPath,
        'date' => $date,
    ]);

    // Ambil ID numerik yang dibuat otomatis oleh MySQL, lalu sediakan juga
    // format nomor keluhan yang ditampilkan pada antarmuka.
    $newComplaintId = (int) $pdo->lastInsertId();
    jsonResponse([
        'success' => true,
        'message' => 'Keluhan berhasil disimpan ke database.',
        'id_keluhan' => $newComplaintId,
        'id' => 'KL-' . str_pad((string) $newComplaintId, 4, '0', STR_PAD_LEFT),
    ], 201);
} catch (Throwable $e) {
    error_log('Kelola Kost API error: ' . $e->getMessage());
    jsonResponse([
        'success' => false,
        'message' => 'Terjadi kesalahan server/database. Periksa konfigurasi database dan pastikan file SQL sudah diimpor.',
    ], 500);
}
