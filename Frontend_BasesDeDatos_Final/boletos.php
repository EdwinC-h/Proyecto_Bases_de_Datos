<?php include "conexion.php"; ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Boletos Vendidos</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>
<body>

<header class="main-header">
    <h1>🎫 Control de Ventas</h1>
    <nav class="main-nav">
        <a href="index.php" class="nav-link">Buses</a>
        <a href="pasajeros.php" class="nav-link">Pasajeros</a>
        <a href="boletos.php" class="nav-link active">Boletos</a>
    </nav>
</header>

<main class="container">
    <section class="table-card">
        <div class="table-header">
            <h2>Registro de Boletos Vendidos</h2>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Pasajero</th>
                    <th>Ruta</th>
                    <th>Asiento</th>
                    <th>Precio</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $sql = "
                SELECT b.id_boleto, 
                       CONCAT(p.nombre,' ',p.apellido) AS pasajero, 
                       CONCAT(r.origen,' - ',r.destino) AS ruta, 
                       b.asiento, 
                       b.precio
                FROM boletos b
                JOIN pasajeros p ON b.id_pasajero = p.id_pasajero
                JOIN rutas r ON b.id_ruta = r.id_ruta
                ";

                $res = $conn->query($sql);
                while ($row = $res->fetch_assoc()) {
                    echo "<tr>
                        <td><span class='badge-id'>#{$row['id_boleto']}</span></td>
                        <td><strong>{$row['pasajero']}</strong></td>
                        <td><span class='ruta-text'>{$row['ruta']}</span></td>
                        <td><span class='asiento-label'>Cant: {$row['asiento']}</span></td>
                        <td><strong class='precio-tag'>$ " . number_format($row['precio'], 2) . "</strong></td>
                    </tr>";
                }
                ?>
            </tbody>
        </table>
    </section>

   
</main>

</body>
</html>