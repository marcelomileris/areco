<?php
class ApiModel extends Core
{

    public function list()
    {
        $sql = "SELECT id, name, description, price, quantity, unitmeasure, sku, barcode, category, brand, active
                FROM products WHERE active = 1 ORDER BY id ASC";
        $data = $this->db->select($sql);
        // return (count($data) > 0) ? $data : [];
        return array("success" => true, "message" => "success! ", "data" => $data);
    }

    public function add(array $data)
    {
        return $this->db->insert("products", $data);
    }

    // Exclui um evento de forma lógica pelo ID
    public function del($id)
    {
        return $this->db->delete("products", "id=$id");
    }

    public function upd($id, $data)
    {
        return $this->db->update("products", $data, "id=$id");
    }

    // Recupera o evento pelo ID
    public function getById($id)
    {
        $sql = "SELECT id
                FROM products WHERE id = $id";
        $data = $this->db->select($sql);
        return $data;
    }

    // Verifica se há duplicidade nos dados
    public function isDuplicated($id, array $data)
    {

        $data = array("name" => $data["name"], "sku" => $data["sku"], "barcode" => $data["barcode"]);

        if ($id === null):
            $ret = $this->db->select("SELECT id FROM products 
               WHERE name = :name OR sku = :sku OR barcode = :barcode", $data);
            return count($ret) > 0;
        endif;


        $ret = $this->db->select("SELECT id FROM products 
               WHERE name = :name OR sku = :sku OR barcode = :barcode", $data);

        if ($ret[0]["id"] ==  $id) :
            return false;
        else :
            $ret = $this->db->select("SELECT id FROM products 
               WHERE name = :name OR sku = :sku OR barcode = :barcode", $data);
            return count($ret) > 0;
        endif;
    }
}
