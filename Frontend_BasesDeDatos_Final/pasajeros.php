<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include "conexion.php";

/* 
   GUARDAR / ACTUALIZAR
 */
if (isset($_POST['guardar'])) {
    $id_pasajero = $_POST['id_pasajero'] ?? "";
    $nombre   = $_POST['nombre'];
    $apellido = $_POST['apellido'];
    $email    = $_POST['email'];
    $telefono = $_POST['telefono'];

    $id_boleto = $_POST['id_boleto'] ?? "";
    $id_ruta   = $_POST['id_ruta'];
    $id_bus    = $_POST['id_bus'];
    $asiento   = $_POST['asiento'];
    $precio    = $_POST['precio'];

    if (empty($id_pasajero)) {
        // --- NUEVO PASAJERO ---
        $stmtP = $conn->prepare("INSERT INTO pasajeros (nombre, apellido, email, telefono) VALUES (?, ?, ?, ?)");
        $stmtP->bind_param("ssss", $nombre, $apellido, $email, $telefono);
        $stmtP->execute();
        $id_pasajero = $conn->insert_id;

        // --- NUEVO BOLETO ---
        $stmtB = $conn->prepare("INSERT INTO boletos (id_pasajero, id_ruta, id_bus, asiento, precio) VALUES (?, ?, ?, ?, ?)");
        $stmtB->bind_param("iiisd", $id_pasajero, $id_ruta, $id_bus, $asiento, $precio);
        $stmtB->execute();
    } else {
        // --- ACTUALIZAR PASAJERO ---
        $stmtP = $conn->prepare("UPDATE pasajeros SET nombre=?, apellido=?, email=?, telefono=? WHERE id_pasajero=?");
        $stmtP->bind_param("ssssi", $nombre, $apellido, $email, $telefono, $id_pasajero);
        $stmtP->execute();

        if (!empty($id_boleto)) {
            // ACTUALIZAR BOLETO
            $stmtB = $conn->prepare("UPDATE boletos SET id_ruta=?, id_bus=?, asiento=?, precio=? WHERE id_boleto=?");
            $stmtB->bind_param("iiidi", $id_ruta, $id_bus, $asiento, $precio, $id_boleto);
            $stmtB->execute();
        } else {
            // CREAR BOLETO SI NO EXISTÍA
            $stmtB = $conn->prepare("INSERT INTO boletos (id_pasajero, id_ruta, id_bus, asiento, precio) VALUES (?, ?, ?, ?, ?)");
            $stmtB->bind_param("iiisd", $id_pasajero, $id_ruta, $id_bus, $asiento, $precio);
            $stmtB->execute();
        }
    }
    header("Location: pasajeros.php");
    exit;
}

/* 
   ELIMINAR
 */
if (isset($_GET['eliminar'])) {
    $id = $_GET['eliminar'];
    // Primero eliminamos el boleto por la restricción de llave foránea
    $stmt1 = $conn->prepare("DELETE FROM boletos WHERE id_pasajero=?");
    $stmt1->bind_param("i", $id);
    $stmt1->execute();

    $stmt2 = $conn->prepare("DELETE FROM pasajeros WHERE id_pasajero=?");
    $stmt2->bind_param("i", $id);
    $stmt2->execute();

    header("Location: pasajeros.php");
    exit;
}

/* 
   EDITAR (Cargar datos)
*/
$editar = false;
$pasajero = ["id_pasajero"=>"","nombre"=>"","apellido"=>"","email"=>"","telefono"=>"","id_boleto"=>"","id_ruta"=>"","id_bus"=>"","asiento"=>"","precio"=>""];

if (isset($_GET['editar'])) {
    $editar = true;
    $stmt = $conn->prepare("SELECT p.*, b.id_boleto, b.id_ruta, b.id_bus, b.asiento, b.precio 
                            FROM pasajeros p 
                            LEFT JOIN boletos b ON p.id_pasajero = b.id_pasajero 
                            WHERE p.id_pasajero = ?");
    $stmt->bind_param("i", $_GET['editar']);
    $stmt->execute();
    $res = $stmt->get_result();
    $pasajero = $res->fetch_assoc();
}

// Listas para la tabla y selects
$lista = $conn->query("SELECT * FROM pasajeros");
$rutas = $conn->query("SELECT * FROM rutas");
$buses = $conn->query("SELECT * FROM buses");
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Pasajeros</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>
<body>

<header class="main-header">
    <div class="header-content">
        <h1><span class="icon"></span> Pasajeros</h1>
        <nav class="main-nav">
            <a href="index.php" class="nav-link">Buses</a>
            <a href="pasajeros.php" class="nav-link active">Pasajeros</a>
            <a href="boletos.php" class="nav-link">Boletos</a>
        </nav>
    </div>
</header>

<main class="container">
    <form method="POST" class="main-form">
        <h2><?= $editar ? "Editar Pasajero y Boleto" : "Nuevo Pasajero" ?></h2>
        
        <input type="hidden" name="id_pasajero" value="<?= $pasajero['id_pasajero'] ?>">
        <input type="hidden" name="id_boleto" value="<?= $pasajero['id_boleto'] ?>">

        <fieldset>
            <legend>Datos Personales</legend>
            Nombre: <input name="nombre" value="<?= $pasajero['nombre'] ?>" required><br><br>
            Apellido: <input name="apellido" value="<?= $pasajero['apellido'] ?>" required><br><br>
            Email: <input name="email" type="email" value="<?= $pasajero['email'] ?>"><br><br>
            Teléfono: <input name="telefono" value="<?= $pasajero['telefono'] ?>" required><br><br>
        </fieldset>

        <fieldset>
            <legend>Información del Viaje</legend>
            Ruta:
            <select name="id_ruta" required>
                <option value="">Seleccione una ruta</option>
                <?php while($r = $rutas->fetch_assoc()): ?>
                    <option value="<?= $r['id_ruta'] ?>" <?= $r['id_ruta']==$pasajero['id_ruta']?'selected':'' ?>>
                        <?= $r['origen'] ?> → <?= $r['destino'] ?>
                    </option>
                <?php endwhile; ?>
            </select><br><br>

            Bus:
            <select name="id_bus" required>
                <option value="">Seleccione un bus</option>
                <?php while($b = $buses->fetch_assoc()): ?>
                    <option value="<?= $b['id_bus'] ?>" <?= $b['id_bus']==$pasajero['id_bus']?'selected':'' ?>>
                        <?= $b['placa'] ?> (<?= $b['modelo'] ?>)
                    </option>
                <?php endwhile; ?>
            </select><br><br>

            Asiento: <input type="number" name="asiento" min="1" max="60" value="<?= $pasajero['asiento'] ?>" required><br><br>
            Precio: <input type="number" step="0.01" name="precio" min="1" max="100" value="<?= $pasajero['precio'] ?>" required><br><br>
        </fieldset>

        <div style="clear:both"></div><br>
        <div style="text-align: center;">
            <button name="guardar" class="btn-submit">
                <?= $editar ? "Actualizar Registro" : "Registrar Pasajero" ?>
            </button>
        </div>
    </form>

    <hr>

    <h2>Pasajeros Registrados</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th><th>Nombre</th><th>Apellido</th><th>Email</th><th>Teléfono</th><th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php while($p = $lista->fetch_assoc()): ?>
            <tr>
                <td><?= $p['id_pasajero'] ?></td>
                <td><?= $p['nombre'] ?></td>
                <td><?= $p['apellido'] ?></td>
                <td><?= $p['email'] ?></td>
                <td><?= $p['telefono'] ?></td>
                <td>
                    <a href="?editar=<?= $p['id_pasajero'] ?>" class="btn-edit">Editar</a> | 
                    <a href="?eliminar=<?= $p['id_pasajero'] ?>" class="btn-delete" onclick="return confirm('¿Eliminar pasajero y su boleto?')">Eliminar</a>
                </td>
            </tr>
            <?php endwhile; ?>
        </tbody>
    </table>
</main>

</body>
</html>