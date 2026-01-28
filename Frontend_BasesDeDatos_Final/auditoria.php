<?php
include "conexion.php";

function registrarAuditoria($tabla, $operacion, $id_registro, $usuario = "admin", $datos_anteriores = null, $datos_nuevos = null, $descripcion = "") {
    global $conn;
    
    $stmt = $conn->prepare("INSERT INTO auditoria 
        (tabla, operacion, id_registro, usuario, datos_anteriores, datos_nuevos, descripcion) 
        VALUES (?, ?, ?, ?, ?, ?, ?)");
    
    $datos_anteriores_json = $datos_anteriores ? json_encode($datos_anteriores) : null;
    $datos_nuevos_json = $datos_nuevos ? json_encode($datos_nuevos) : null;

    $stmt->bind_param("ssissss", $tabla, $operacion, $id_registro, $usuario, $datos_anteriores_json, $datos_nuevos_json, $descripcion);
    $stmt->execute();
    $stmt->close();
}
?>