<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
include "conexion.php";


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

    if ($id_pasajero == "") {
        // NUEVO PASAJERO
        $conn->query("INSERT INTO pasajeros (nombre,apellido,email,telefono)
                      VALUES ('$nombre','$apellido','$email','$telefono')");
        $id_pasajero = $conn->insert_id;

        // NUEVO BOLETO
        $conn->query("INSERT INTO boletos (id_pasajero,id_ruta,id_bus,asiento,precio)
                      VALUES ($id_pasajero,$id_ruta,$id_bus,$asiento,$precio)");
    } else {
        // ACTUALIZAR PASAJERO
        $conn->query("UPDATE pasajeros SET
                        nombre='$nombre',
                        apellido='$apellido',
                        email='$email',
                        telefono='$telefono'
                      WHERE id_pasajero=$id_pasajero");

        // ACTUALIZAR BOLETO si existe
        if(!empty($id_boleto)) {
            $conn->query("UPDATE boletos SET
                            id_ruta=$id_ruta,
                            id_bus=$id_bus,
                            asiento=$asiento,
                            precio=$precio
                          WHERE id_boleto=$id_boleto");
        } else {
            // Crear boleto si no existía
            $conn->query("INSERT INTO boletos (id_pasajero,id_ruta,id_bus,asiento,precio)
                          VALUES ($id_pasajero,$id_ruta,$id_bus,$asiento,$precio)");
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
    $conn->query("DELETE FROM boletos WHERE id_pasajero=$id");
    $conn->query("DELETE FROM pasajeros WHERE id_pasajero=$id");
    header("Location: pasajeros.php");
    exit;
}

/*
   EDITAR
 */
$editar = false;
$pasajero = [
    "id_pasajero"=>"",
    "nombre"=>"",
    "apellido"=>"",
    "email"=>"",
    "telefono"=>"",
    "id_boleto"=>"",
    "id_ruta"=>"",
    "id_bus"=>"",
    "asiento"=>"",
    "precio"=>""
];

if (isset($_GET['editar'])) {
    $editar = true;
    $sql = "SELECT p.*, b.id_boleto, b.id_ruta, b.id_bus, b.asiento, b.precio
            FROM pasajeros p
            LEFT JOIN boletos b ON p.id_pasajero = b.id_pasajero
            WHERE p.id_pasajero=".$_GET['editar'];
    $res = $conn->query($sql);
    if($res) {
        $pasajero = $res->fetch_assoc();
    }
}

/*
   LISTAS
 */
$lista = $conn->query("SELECT * FROM pasajeros");
$rutas = $conn->query("SELECT * FROM rutas");
$buses = $conn->query("SELECT * FROM buses");
?>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>Gestión de Pasajeros</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>
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

<form method="POST">
<input type="hidden" name="id_pasajero" value="<?= $pasajero['id_pasajero'] ?>">
<input type="hidden" name="id_boleto" value="<?= $pasajero['id_boleto'] ?>">

<fieldset>
<legend>Pasajero</legend>
Nombre: <input name="nombre" value="<?= $pasajero['nombre'] ?>" required><br><br>
Apellido: <input name="apellido" value="<?= $pasajero['apellido'] ?>" required><br><br>
Email: <input name="email" value="<?= $pasajero['email'] ?>"><br><br>
Teléfono: <input name="telefono" value="<?= $pasajero['telefono'] ?>" required><br><br>
</fieldset>

<fieldset>
<legend>Boleto</legend>

Ruta:
<select name="id_ruta" required>
<?php while($r = $rutas->fetch_assoc()): ?>
<option value="<?= $r['id_ruta'] ?>"
<?= $r['id_ruta']==$pasajero['id_ruta']?'selected':'' ?>>
<?= $r['origen'] ?> → <?= $r['destino'] ?>
</option>
<?php endwhile; ?>
</select><br><br>

Bus:
<select name="id_bus" required>
<?php while($b = $buses->fetch_assoc()): ?>
<option value="<?= $b['id_bus'] ?>"
<?= $b['id_bus']==$pasajero['id_bus']?'selected':'' ?>>
<?= $b['placa'] ?>
</option>
<?php endwhile; ?>
</select><br><br>

Asiento: <input type="number" name="asiento" value="<?= $pasajero['asiento'] ?>" required><br><br>
Precio: <input type="number" step="0.01" name="precio" value="<?= $pasajero['precio'] ?>" required><br><br>
</fieldset>

<div style="clear:both"></div><br>
<button name="guardar"><?= $editar ? "Actualizar" : "Registrar" ?></button>
</form>

<hr>

<h2>Pasajeros Registrados</h2>

<table>
<tr>
<th>ID</th><th>Nombre</th><th>Apellido</th><th>Email</th><th>Teléfono</th><th>Acciones</th>
</tr>

<?php while($p = $lista->fetch_assoc()): ?>
<tr>
<td><?= $p['id_pasajero'] ?></td>
<td><?= $p['nombre'] ?></td>
<td><?= $p['apellido'] ?></td>
<td><?= $p['email'] ?></td>
<td><?= $p['telefono'] ?></td>
<td>
<a href="?editar=<?= $p['id_pasajero'] ?>">Editar</a> |
<a href="?eliminar=<?= $p['id_pasajero'] ?>" onclick="return confirm('¿Eliminar todo?')">Eliminar</a>
</td>
</tr>
<?php endwhile; ?>
</table>

</body>
</html>