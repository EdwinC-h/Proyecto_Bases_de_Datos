<?php include "conexion.php"; ?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flota de Buses</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>
<body>

<header class="main-header">
    <h1> Sistema de Flota de Buses</h1>
    <nav class="main-nav">
        <a href="index.php" class="nav-link active">Buses</a>
        <a href="pasajeros.php" class="nav-link">Pasajeros</a>
        <a href="boletos.php" class="nav-link">Boletos</a>
    </nav>
</header>

<main class="container">
    <section class="table-card">
        <div class="table-header">
            <h2>Listado de Buses Disponibles</h2>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Modelo</th>
                    <th>Placa</th>
                    <th>Año</th>
                    <th>Capacidad</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $result = $conn->query("SELECT * FROM buses");
                while ($row = $result->fetch_assoc()) {
                    echo "<tr>
                        <td><span class='badge-id'>#{$row['id_bus']}</span></td>
                        <td><strong>{$row['modelo']}</strong></td>
                        <td><code class='plate'>{$row['placa']}</code></td>
                        <td>{$row['año']}</td>
                        <td><span class='capacity'>{$row['capacidad']} asientos</span></td>
                    </tr>";
                }
                ?>
            </tbody>
        </table>
    </section>

</main>

</body>
</html>