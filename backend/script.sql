CREATE TABLE products (
    id INT PRIMARY KEY IDENTITY(1,1),              		
    name NVARCHAR(100) NOT NULL,                        
    description NVARCHAR(MAX) NULL,                     
    price DECIMAL(18, 2) NOT NULL,                      
    quantity INT NOT NULL,                         		
    unitmeasure NVARCHAR(50) NOT NULL,                  
    sku NVARCHAR(50) UNIQUE NOT NULL,                   
    barcode NVARCHAR(13) UNIQUE NULL,                   
    category NVARCHAR(50) NULL,                         
    brand NVARCHAR(50) NULL,                            
    createdat DATETIME DEFAULT GETDATE() NOT NULL,      
    updatedat DATETIME DEFAULT NULL,      
    active BIT DEFAULT 1 NOT NULL                       
)
GO

CREATE TRIGGER trg_UpdateProducts
ON products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE products
    SET updatedat = GETDATE()
    FROM inserted i
    WHERE products.id = i.id;
END
GO

INSERT INTO products (name, description, price, quantity, unitmeasure, sku, barcode, category, brand, createdat, updatedat, active)
VALUES 
-- Grupo 1: Eletrônicos
('Laptop Modelo A', 'Notebook de 14 polegadas com processador Intel i5', 1000.00, 50, 'Unidades', 'SKU001', '1000000000001', 'Eletrônicos', 'TechBrand', GETDATE(), GETDATE(), 1),
('Laptop Modelo B', 'Notebook de 15 polegadas com processador Intel i7', 1200.00, 50, 'Unidades', 'SKU002', '1000000000002', 'Eletrônicos', 'TechBrand', GETDATE(), GETDATE(), 1),
('Laptop Modelo C', 'Notebook de 17 polegadas com processador Intel i9', 1500.00, 30, 'Unidades', 'SKU003', '1000000000003', 'Eletrônicos', 'TechBrand', GETDATE(), GETDATE(), 1),
('Smartphone Modelo A', 'Smartphone com tela de 5.5 polegadas e 64GB de armazenamento', 600.00, 100, 'Unidades', 'SKU004', '1000000000004', 'Eletrônicos', 'PhoneBrand', GETDATE(), GETDATE(), 1),
('Smartphone Modelo B', 'Smartphone com tela de 6.5 polegadas e 128GB de armazenamento', 800.00, 100, 'Unidades', 'SKU005', '1000000000005', 'Eletrônicos', 'PhoneBrand', GETDATE(), GETDATE(), 1),
('Smartphone Modelo C', 'Smartphone com tela de 7 polegadas e 256GB de armazenamento', 1000.00, 70, 'Unidades', 'SKU006', '1000000000006', 'Eletrônicos', 'PhoneBrand', GETDATE(), GETDATE(), 1),
('Tablet Modelo A', 'Tablet de 10 polegadas com 64GB de armazenamento', 300.00, 80, 'Unidades', 'SKU007', '1000000000007', 'Eletrônicos', 'TechBrand', GETDATE(), GETDATE(), 1),
('Tablet Modelo B', 'Tablet de 12 polegadas com 128GB de armazenamento', 500.00, 60, 'Unidades', 'SKU008', '1000000000008', 'Eletrônicos', 'TechBrand', GETDATE(), GETDATE(), 1),
('Tablet Modelo C', 'Tablet de 14 polegadas com 256GB de armazenamento', 700.00, 40, 'Unidades', 'SKU009', '1000000000009', 'Eletrônicos', 'TechBrand', GETDATE(), GETDATE(), 1),

-- Grupo 2: Acessórios
('Mouse Sem Fio A', 'Mouse sem fio ergonômico modelo A', 25.00, 200, 'Unidades', 'SKU010', '1000000000010', 'Acessórios', 'AccessoryBrand', GETDATE(), GETDATE(), 1),
('Mouse Sem Fio B', 'Mouse sem fio ergonômico modelo B', 30.00, 180, 'Unidades', 'SKU011', '1000000000011', 'Acessórios', 'AccessoryBrand', GETDATE(), GETDATE(), 1),
('Mouse Sem Fio C', 'Mouse sem fio ergonômico modelo C', 35.00, 150, 'Unidades', 'SKU012', '1000000000012', 'Acessórios', 'AccessoryBrand', GETDATE(), GETDATE(), 1),
('Teclado Gamer A', 'Teclado mecânico com iluminação RGB modelo A', 100.00, 150, 'Unidades', 'SKU013', '1000000000013', 'Acessórios', 'AccessoryBrand', GETDATE(), GETDATE(), 1),
('Teclado Gamer B', 'Teclado mecânico com iluminação RGB modelo B', 110.00, 140, 'Unidades', 'SKU014', '1000000000014', 'Acessórios', 'AccessoryBrand', GETDATE(), GETDATE(), 1),
('Teclado Gamer C', 'Teclado mecânico com iluminação RGB modelo C', 120.00, 130, 'Unidades', 'SKU015', '1000000000015', 'Acessórios', 'AccessoryBrand', GETDATE(), GETDATE(), 1),
('Fone de Ouvido com Fio A', 'Fone de ouvido com fio modelo A', 20.00, 250, 'Unidades', 'SKU016', '1000000000016', 'Acessórios', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Fone de Ouvido com Fio B', 'Fone de ouvido com fio modelo B', 25.00, 240, 'Unidades', 'SKU017', '1000000000017', 'Acessórios', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Fone de Ouvido com Fio C', 'Fone de ouvido com fio modelo C', 30.00, 230, 'Unidades', 'SKU018', '1000000000018', 'Acessórios', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Fone de Ouvido Bluetooth A', 'Fone de ouvido Bluetooth modelo A', 50.00, 200, 'Unidades', 'SKU019', '1000000000019', 'Acessórios', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Fone de Ouvido Bluetooth B', 'Fone de ouvido Bluetooth modelo B', 60.00, 180, 'Unidades', 'SKU020', '1000000000020', 'Acessórios', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Fone de Ouvido Bluetooth C', 'Fone de ouvido Bluetooth modelo C', 70.00, 160, 'Unidades', 'SKU021', '1000000000021', 'Acessórios', 'SoundBrand', GETDATE(), GETDATE(), 1),

-- Grupo 3: Áudio
('Caixa de Som Bluetooth A', 'Caixa de som Bluetooth portátil modelo A', 60.00, 75, 'Unidades', 'SKU022', '1000000000022', 'Áudio', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Caixa de Som Bluetooth B', 'Caixa de som Bluetooth portátil modelo B', 70.00, 70, 'Unidades', 'SKU023', '1000000000023', 'Áudio', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Caixa de Som Bluetooth C', 'Caixa de som Bluetooth portátil modelo C', 80.00, 65, 'Unidades', 'SKU024', '1000000000024', 'Áudio', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Fone de Ouvido com Cancelamento de Ruído A', 'Fone de ouvido over-ear com cancelamento de ruído modelo A', 150.00, 60, 'Unidades', 'SKU025', '1000000000025', 'Áudio', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Fone de Ouvido com Cancelamento de Ruído B', 'Fone de ouvido over-ear com cancelamento de ruído modelo B', 160.00, 55, 'Unidades', 'SKU026', '1000000000026', 'Áudio', 'SoundBrand', GETDATE(), GETDATE(), 1),
('Fone de Ouvido com Cancelamento de Ruído C', 'Fone de ouvido over-ear com cancelamento de ruído modelo C', 170.00, 50, 'Unidades', 'SKU027', '1000000000027', 'Áudio', 'SoundBrand', GETDATE(), GETDATE(), 1),

-- Grupo 4: Armazenamento
('HD Externo 500GB', 'HD externo de 500GB USB 3.0', 50.00, 120, 'Unidades', 'SKU028', '1000000000028', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),
('HD Externo 1TB', 'HD externo de 1TB USB 3.0', 75.00, 110, 'Unidades', 'SKU029', '1000000000029', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),
('HD Externo 2TB', 'HD externo de 2TB USB 3.0', 100.00, 100, 'Unidades', 'SKU030', '1000000000030', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),
('HD Externo 4TB', 'HD externo de 4TB USB 3.0', 150.00, 80, 'Unidades', 'SKU031', '1000000000031', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),
('Pen Drive 32GB', 'Pen drive USB 3.0 de 32GB', 10.00, 300, 'Unidades', 'SKU032', '1000000000032', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),
('Pen Drive 64GB', 'Pen drive USB 3.0 de 64GB', 15.00, 280, 'Unidades', 'SKU033', '1000000000033', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),
('Pen Drive 128GB', 'Pen drive USB 3.0 de 128GB', 20.00, 260, 'Unidades', 'SKU034', '1000000000034', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),
('Pen Drive 256GB', 'Pen drive USB 3.0 de 256GB', 30.00, 240, 'Unidades', 'SKU035', '1000000000035', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),
('SSD 250GB', 'SSD interno de 250GB', 50.00, 130, 'Unidades', 'SKU036', '1000000000036', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),
('SSD 500GB', 'SSD interno de 500GB', 75.00, 120, 'Unidades', 'SKU037', '1000000000037', 'Armazenamento', 'StorageBrand', GETDATE(), GETDATE(), 1),

-- Grupo 5: Monitores
('Monitor 24 Polegadas', 'Monitor Full HD de 24 polegadas', 150.00, 60, 'Unidades', 'SKU038', '1000000000038', 'Eletrônicos', 'DisplayBrand', GETDATE(), GETDATE(), 1),
('Monitor 27 Polegadas', 'Monitor 4K UHD de 27 polegadas', 350.00, 50, 'Unidades', 'SKU039', '1000000000039', 'Eletrônicos', 'DisplayBrand', GETDATE(), GETDATE(), 1),
('Monitor 32 Polegadas', 'Monitor QHD de 32 polegadas', 500.00, 40, 'Unidades', 'SKU040', '1000000000040', 'Eletrônicos', 'DisplayBrand', GETDATE(), GETDATE(), 1),

-- Grupo 6: Periféricos
('Webcam HD', 'Webcam HD 720p com microfone embutido', 40.00, 80, 'Unidades', 'SKU041', '1000000000041', 'Acessórios', 'TechBrand', GETDATE(), GETDATE(), 1),
('Webcam Full HD', 'Webcam Full HD 1080p com microfone embutido', 60.00, 75, 'Unidades', 'SKU042', '1000000000042', 'Acessórios', 'TechBrand', GETDATE(), GETDATE(), 1),
('Webcam 4K', 'Webcam 4K UHD com microfone embutido', 100.00, 50, 'Unidades', 'SKU043', '1000000000043', 'Acessórios', 'TechBrand', GETDATE(), GETDATE(), 1),

-- Grupo 7: Impressoras
('Impressora Jato de Tinta A', 'Impressora jato de tinta colorida modelo A', 100.00, 50, 'Unidades', 'SKU044', '1000000000044', 'Eletrônicos', 'PrintBrand', GETDATE(), GETDATE(), 1),
('Impressora Jato de Tinta B', 'Impressora jato de tinta colorida modelo B', 120.00, 45, 'Unidades', 'SKU045', '1000000000045', 'Eletrônicos', 'PrintBrand', GETDATE(), GETDATE(), 1),
('Impressora Laser A', 'Impressora laser monocromática modelo A', 150.00, 40, 'Unidades', 'SKU046', '1000000000046', 'Eletrônicos', 'PrintBrand', GETDATE(), GETDATE(), 1),
('Impressora Laser B', 'Impressora laser colorida modelo B', 200.00, 35, 'Unidades', 'SKU047', '1000000000047', 'Eletrônicos', 'PrintBrand', GETDATE(), GETDATE(), 1),

-- Grupo 8: Relógios Inteligentes
('Smartwatch Modelo A', 'Relógio inteligente com monitor de batimentos cardíacos modelo A', 150.00, 90, 'Unidades', 'SKU048', '1000000000048', 'Wearables', 'WatchBrand', GETDATE(), GETDATE(), 1),
('Smartwatch Modelo B', 'Relógio inteligente com GPS e monitor de sono modelo B', 200.00, 80, 'Unidades', 'SKU049', '1000000000049', 'Wearables', 'WatchBrand', GETDATE(), GETDATE(), 1),
('Smartwatch Modelo C', 'Relógio inteligente com NFC e rastreamento de atividades modelo C', 250.00, 70, 'Unidades', 'SKU050', '1000000000050', 'Wearables', 'WatchBrand', GETDATE(), GETDATE(), 1),

-- Grupo 9: Consoles de Jogos
('Console de Jogos A', 'Console de jogos de última geração modelo A', 400.00, 50, 'Unidades', 'SKU051', '1000000000051', 'Eletrônicos', 'GameBrand', GETDATE(), GETDATE(), 1),
('Console de Jogos B', 'Console de jogos de última geração modelo B', 500.00, 45, 'Unidades', 'SKU052', '1000000000052', 'Eletrônicos', 'GameBrand', GETDATE(), GETDATE(), 1),
('Console de Jogos C', 'Console de jogos de última geração modelo C', 600.00, 40, 'Unidades', 'SKU053', '1000000000053', 'Eletrônicos', 'GameBrand', GETDATE(), GETDATE(), 1),

-- Grupo 10: Acessórios para Jogos
('Controle de Jogos A', 'Controle de jogos sem fio modelo A', 50.00, 100, 'Unidades', 'SKU054', '1000000000054', 'Acessórios', 'GameBrand', GETDATE(), GETDATE(), 1),
('Controle de Jogos B', 'Controle de jogos sem fio modelo B', 60.00, 90, 'Unidades', 'SKU055', '1000000000055', 'Acessórios', 'GameBrand', GETDATE(), GETDATE(), 1),
('Controle de Jogos C', 'Controle de jogos sem fio modelo C', 70.00, 80, 'Unidades', 'SKU056', '1000000000056', 'Acessórios', 'GameBrand', GETDATE(), GETDATE(), 1),
('Volante de Jogos A', 'Volante de jogos com pedais modelo A', 100.00, 50, 'Unidades', 'SKU057', '1000000000057', 'Acessórios', 'GameBrand', GETDATE(), GETDATE(), 1),
('Volante de Jogos B', 'Volante de jogos com pedais e câmbio modelo B', 150.00, 45, 'Unidades', 'SKU058', '1000000000058', 'Acessórios', 'GameBrand', GETDATE(), GETDATE(), 1),
('Volante de Jogos C', 'Volante de jogos com pedais, câmbio e força feedback modelo C', 200.00, 40, 'Unidades', 'SKU059', '1000000000059', 'Acessórios', 'GameBrand', GETDATE(), GETDATE(), 1),

-- Grupo 11: Smartphones
('Smartphone Avançado A', 'Smartphone com tela AMOLED e 5G modelo A', 800.00, 100, 'Unidades', 'SKU060', '1000000000060', 'Eletrônicos', 'PhoneBrand', GETDATE(), GETDATE(), 1),
('Smartphone Avançado B', 'Smartphone com câmera tripla e bateria de longa duração modelo B', 900.00, 95, 'Unidades', 'SKU061', '1000000000061', 'Eletrônicos', 'PhoneBrand', GETDATE(), GETDATE(), 1),
('Smartphone Avançado C', 'Smartphone com processador de última geração e 256GB de armazenamento modelo C', 1000.00, 90, 'Unidades', 'SKU062', '1000000000062', 'Eletrônicos', 'PhoneBrand', GETDATE(), GETDATE(), 1),

-- Grupo 12: Tablets
('Tablet Pro A', 'Tablet com tela de 11 polegadas e caneta modelo A', 600.00, 80, 'Unidades', 'SKU063', '1000000000063', 'Eletrônicos', 'TabletBrand', GETDATE(), GETDATE(), 1)
