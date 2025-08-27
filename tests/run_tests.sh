#!/bin/bash

set -euo pipefail

# Função para testar a deleção de um arquivo
test_del_file() {
  echo "Teste: deletar arquivo..."
  touch test_file.txt
  python3 del test_file.txt
  if [ ! -f test_file.txt ]; then
    echo "  ✓ Arquivo deletado com sucesso"
  else
    echo "  ✗ Falha ao deletar arquivo"
  fi
}

# Função para testar a deleção de um diretório
test_del_directory() {
  echo "Teste: deletar diretório..."
  mkdir test_dir
  touch test_dir/file.txt
  python3 del test_dir
  if [ ! -d test_dir ]; then
    echo "  ✓ Diretório deletado com sucesso"
  else
    echo "  ✗ Falha ao deletar diretório"
  fi
}

# Função para testar a deleção de um arquivo inexistente
test_del_nonexistent() {
  echo "Teste: arquivo inexistente..."
  output=$(python3 del nonexistent.txt 2>&1 || true)
  if echo "$output" | grep -q -i "not found"; then
    echo "  ✓ Erro tratado corretamente"
  else
    echo "  ✗ Erro não tratado: $output"
  fi
}

# Função para testar a deleção sem argumentos
test_del_no_args() {
  echo "Teste: sem argumentos..."
  output=$(python3 del 2>&1 || true)
  if echo "$output" | grep -q -i "usage"; then
    echo "  ✓ Erro sem argumentos tratado"
  else
    echo "  ✗ Erro não tratado: $output"
  fi
}

# Função para executar os testes de integração do size.py
test_size_integration() {
  echo "Teste size integração..."
  TEST_DIR="/tmp/size_test_$$"
  mkdir -p "$TEST_DIR"
  pushd "$TEST_DIR" >/dev/null

  echo "  Arquivo simples..."
  echo "conteúdo" > test_file.txt
  python3 "$SRC_DIR/size" test_file.txt

  echo "  Diretório..."
  mkdir test_dir
  echo "a" > test_dir/a.txt
  echo "b" > test_dir/b.txt
  python3 "$SRC_DIR/size" test_dir

  popd >/dev/null
  rm -rf "$TEST_DIR"
}

# Função principal para executar todos os testes
main() {
  echo "========= Iniciando testes ========="
  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  SRC_DIR="$SCRIPT_DIR/../src"

  echo ""
  echo "========= Testando del.py ========="
  cd "$SRC_DIR"
  test_del_file
  test_del_directory
  test_del_nonexistent
  test_del_no_args

  echo ""
  echo "========= Testando size.py ========="
  cd "$SCRIPT_DIR"
  python3 -m pytest test_size.py -v
  test_size_integration

  echo ""
  echo "========= Todos os testes concluídos ========="
}

main "$@"
