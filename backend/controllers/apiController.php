<?php

class apiController extends Controller
{

    private $data_compare = array(
        "name" => "",
        "description" => "",
        "price" => "",
        "quantity" => "",
        "unitmeasure" => "",
        "sku" => "",
        "barcode" => "",
        "category" => "",
        "brand" => ""
    );

    public function index()
    {
        echo json_encode(array("status" => "server on"));
    }

    public function list()
    {
        // qualquer outro método não será permitido
        if (in_array($_SERVER['REQUEST_METHOD'], array('GET')) === false) :
            echo json_encode(array("success" => false, "message" => "method not allowed", "method" => $_SERVER['REQUEST_METHOD']));
            die();
        endif;
        $apiModel = new ApiModel();
        echo json_encode($apiModel->list());
    }

    public function add()
    {
        // qualquer outro método não será permitido
        if (in_array($_SERVER['REQUEST_METHOD'], array('POST')) === false) :
            echo json_encode(array("success" => false, "message" => "method not allowed", "method" => $_SERVER['REQUEST_METHOD']));
            die();
        endif;

        // Recupera as informações enviadas
        $data = json_decode(file_get_contents('php://input'), true);

        if (count($data) == 0) {
            echo json_encode(array("success" => false, "message" => "Os dados informados estão incorretos"), JSON_UNESCAPED_UNICODE);
            die();
        }

        // Valida se o array enviado possue as chaves corretas
        $isValid = array_diff_key($data, $this->data_compare);
        if (count($isValid) > 0) :
            echo json_encode(array("success" => false, "message" => "Os dados informados estão incorretos"), JSON_UNESCAPED_UNICODE);
            die();
        endif;

        // Prepara o array para inserção no banco de dados
        $apiModel = new ApiModel();

        $isDuplicated = $apiModel->isDuplicated(null, $data);
        if ($isDuplicated) :
            echo json_encode(array("success" => false, "message" => "Produto já cadastrado com essas informações! "));
            die();
        endif;

        $ret = $apiModel->add($data);
        //$data["id"] = $ret;
        echo json_encode(array("success" => true, "message" => "Produto adicionado com sucesso! "), JSON_UNESCAPED_UNICODE);
    }

    public function update($id)
    {
        // qualquer outro método não será permitido
        if (in_array($_SERVER['REQUEST_METHOD'], array('PUT')) === false) :
            echo json_encode(array("success" => false, "message" => "method not allowed", "method" => $_SERVER['REQUEST_METHOD']));
            die();
        endif;

        // Recupera as informações enviadas
        $data = json_decode(file_get_contents('php://input'), true);

        // Valida se o array enviado possue as chaves corretas
        $isValid = array_diff_key($data, $this->data_compare);
        if (count($isValid) > 0) :
            echo json_encode(array("success" => false, "message" => "Os dados informados estão incorretos", "data" => json_encode($data)), JSON_UNESCAPED_UNICODE);
            die();
        endif;

        // Prepara o array para inserção no banco de dados
        $apiModel = new ApiModel();

        // Verifica se há duplicidade no horário informado
        $isDuplicated = $apiModel->isDuplicated($id, $data);
        if ($isDuplicated) :
            echo json_encode(array("success" => false, "message" => "Produto já cadastrado com essas informações! "));
            die();
        endif;

        $ret = $apiModel->upd($id, $data);
        $data["id"] = $id;
        echo json_encode(array("success" => $ret, "message" => $ret == false ? "Ocorreu um erro, tente novamente mais tarde!" : "Produto alterado com sucesso! ", "data" => json_encode($data)), JSON_UNESCAPED_UNICODE);
    }

    public function delete($id)
    {
        // qualquer outro métodonão será permitido
        if (in_array($_SERVER['REQUEST_METHOD'], array('DELETE')) === false) :
            echo json_encode(array("success" => false, "message" => "method not allowed", "method" => $_SERVER['REQUEST_METHOD']));
            die();
        endif;
        $apiModel = new ApiModel();
        $data = $apiModel->getById($id);
        $ret = $apiModel->del($id);
        echo json_encode(array("success" => true, "message" => "Evento excluído com sucesso! ", "data" => json_encode($data)), JSON_UNESCAPED_UNICODE);
    }
}
