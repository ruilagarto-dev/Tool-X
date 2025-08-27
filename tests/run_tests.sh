#!/bin/bash

echo "========= Iniciando testes ========="

# Determinar diretórios base
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR="$SCRIPT_DIR/../src"

echo ""
echo "========= Testando del.py ========="
cd "$SRC_DIR"

echo ""
echo "  1. Testando deleção de arquivo..."
touch test_file.txt
python3 del.py test_file.txt
if [ ! -f "test_file.txt" ]; then
    echo "      ✓ Arquivo deletado com sucesso"
else
    echo "      ✗ Falha ao deletar arquivo"
fi
echo ""

echo "  2. Testando deleção de diretório..."
mkdir test_dir
touch test_dir/file.txt
python3 del.py test_dir
if [ ! -d "test_dir" ]; then
    echo "      ✓ Diretório deletado com sucesso"
else
    echo "      ✗ Falha ao deletar diretório"
fi
echo ""

echo "  3. Testando arquivo inexistente..."
output=$(python3 del.py nonexistent.txt 2>&1)
if echo "$output" | grep -q "not found" || echo "$output" | grep -qi "No such file"; then
    echo "      ✓ Erro tratado corretamente"
else
    echo "      ✗ Erro não tratado: $output"
fi
echo ""

echo "  4. Testando sem argumentos..."
output=$(python3 del.py 2>&1)
if echo "$output" | grep -qi "Missing file argument" || echo "$output" | grep -qi "usage"; then
    echo "      ✓ Erro sem argumentos tratado"
else
    echo "      ✗ Erro sem argumentos não tratado: $output"
fi
echo ""

# Limpar (caso algum teste tenha falhado)
rm -f test_file.txt 2>/dev/null
rm -rf test_dir 2>/dev/null

echo ""
echo "========= Testando size.py ========="

# Voltar ao diretório do script
cd "$SCRIPT_DIR"

# Executar testes unitários
echo ""
echo "1. Executando testes unitários..."
python3 -m pytest test_size.py -v

# Testes de integração
echo ""
echo "2. Executando testes de integração..."

# Criar ambiente de teste temporário
TEST_DIR="/tmp/size_test_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "  2.1. Testando arquivo simples..."
echo "test content" > test_file.txt
python3 "$SRC_DIR/size.py" test_file.txt

echo ""
echo "  2.2. Testando diretório..."
mkdir test_dir
echo "file1" > test_dir/file1.txt
echo "file2" > test_dir/file2.txt
python3 "$SRC_DIR/size.py" test_dir

echo ""
echo "  2.3. Testando múltiplos itens..."
python3 "$SRC_DIR/size.py" test_file.txt test_dir

echo ""
echo "  2.4. Testando arquivo inexistente..."
python3 "$SRC_DIR/size.py" nonexistent.txt

echo ""
echo "  2.5. Testando ajuda..."
python3 "$SRC_DIR/size.py" --help

echo ""
echo "  2.6. Testando versão..."
python3 "$SRC_DIR/size.py" --version

# Limpar ambiente de teste
cd /tmp
rm -rf "$TEST_DIR"

echo ""
echo "========= Todos os testes concluídos ========="
