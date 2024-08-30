<?php
#[AllowDynamicProperties]
class Database extends PDO
{
    private static $instance;

    private function __construct()
    {
        try {
            $dsn = 'sqlsrv:Server=' . DB_HOST . ';Database=' . DB_NAME . ';TrustServerCertificate=True';
            parent::__construct($dsn, DB_USER, DB_PASS);

            // Configurações específicas para SQL Server, se necessário
            $this->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            date_default_timezone_set('America/Sao_Paulo');
        } catch (\PDOException $e) {
            throw new \PDOException($e->getMessage(), (int)$e->getCode());
        }
    }

    public static function getInstance()
    {
        if (!isset(self::$instance) && is_null(self::$instance)) {
            $c = __CLASS__;
            self::$instance = new $c;
        }

        return self::$instance;
    }

    public function select($sql, $array = array(), $fetchMode = PDO::FETCH_ASSOC)
    {
        $sth = $this->prepare($sql);
        if (count($array) > 0) {
            foreach ($array as $key => $value) {
                if (!is_array($value)) {
                    $sth->bindValue(":$key", $value);
                }
            }
        }
        $sth->execute();
        return $sth->fetchAll($fetchMode);
    }

    public function insert($table, $data, $return_id = true)
    {
        ksort($data);

        $fieldNames = implode(', ', array_keys($data));
        $fieldValues = ':' . implode(', :', array_keys($data));

        $sth = $this->prepare("INSERT INTO [$table] ($fieldNames) VALUES ($fieldValues)");

        foreach ($data as $key => $value) {
            $sth->bindValue(":$key", $value);
        }
        $sth->execute();
        $ret = true;
        if ($return_id) {
            $row = $this->select("SELECT SCOPE_IDENTITY() AS uid");
            $ret = $row[0]['uid'];
        }
        return $ret;
    }

    public function update($table, $data, $where)
    {
        ksort($data);
        $fieldDetails = '';
        foreach ($data as $key => $value) {
            $fieldDetails .= "[$key] = :$key,";
        }
        $fieldDetails = rtrim($fieldDetails, ',');
        $sth = $this->prepare("UPDATE [$table] SET $fieldDetails WHERE $where");
        foreach ($data as $key => $value) {
            $sth->bindValue(":$key", $value);
        }
        $result = $sth->execute();
        return $result;
    }

    public function delete($table, $where, $limit = 1)
    {
        return $this->exec("DELETE FROM [$table] WHERE $where");
    }
}
