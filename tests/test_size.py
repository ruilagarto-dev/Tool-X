#!/usr/bin/env python3

import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch, MagicMock

# Adicionar o diretório src ao path para importar o módulo
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from size import convert_size, get_directory_size, get_file_info, main

class TestSizeScript(unittest.TestCase):
    
    def setUp(self):
        """Configurar ambiente de teste."""
        self.temp_dir = tempfile.mkdtemp()
        self.test_file = os.path.join(self.temp_dir, 'test_file.txt')
        self.test_dir = os.path.join(self.temp_dir, 'test_dir')
        
        # Criar arquivo de teste
        with open(self.test_file, 'w') as f:
            f.write('Hello, World!')  # 13 bytes
        
        # Criar diretório com arquivos
        os.makedirs(self.test_dir)
        for i in range(3):
            with open(os.path.join(self.test_dir, f'file_{i}.txt'), 'w') as f:
                f.write('x' * 100)  # 100 bytes cada
    
    def tearDown(self):
        """Limpar ambiente de teste."""
        import shutil
        shutil.rmtree(self.temp_dir)
    
    def test_convert_size(self):
        """Testar conversão de tamanhos."""
        self.assertEqual(convert_size(0), "0 bytes")
        self.assertEqual(convert_size(500), "500.00 bytes")
        self.assertEqual(convert_size(1024), "1.00 KB")
        self.assertEqual(convert_size(1024 * 1024), "1.00 MB")
        self.assertEqual(convert_size(1024 * 1024 * 1024), "1.00 GB")
        
        # Testar diferentes casas decimais
        self.assertEqual(convert_size(1536, 1), "1.5 KB")
        self.assertEqual(convert_size(1536, 0), "2 KB")
    
    def test_get_directory_size(self):
        """Testar cálculo de tamanho de diretório."""
        size = get_directory_size(Path(self.test_dir))
        self.assertEqual(size, 300)  # 3 arquivos × 100 bytes
        
        # Testar diretório vazio
        empty_dir = os.path.join(self.temp_dir, 'empty_dir')
        os.makedirs(empty_dir)
        self.assertEqual(get_directory_size(Path(empty_dir)), 0)
    
    def test_get_file_info_file(self):
        """Testar obtenção de informações de arquivo."""
        info = get_file_info(self.test_file)
        
        self.assertEqual(info['type'], 'file')
        self.assertEqual(info['size'], 13)
        self.assertEqual(info['path'], self.test_file)
        self.assertIn('readable_size', info)
        self.assertIn('modified', info)
    
    def test_get_file_info_directory(self):
        """Testar obtenção de informações de diretório."""
        info = get_file_info(self.test_dir)
        
        self.assertEqual(info['type'], 'directory')
        self.assertEqual(info['size'], 300)
        self.assertEqual(info['path'], self.test_dir)
        self.assertEqual(info['item_count'], 3)
        self.assertIn('readable_size', info)
    
    def test_get_file_info_nonexistent(self):
        """Testar arquivo/diretório inexistente."""
        info = get_file_info('/path/inexistente')
        self.assertEqual(info['type'], 'missing')
        self.assertIn('error', info)
    
    def test_get_file_info_permission_error(self):
        """Testar erro de permissão."""
        # Mock para simular erro de permissão
        with patch('pathlib.Path.exists') as mock_exists:
            mock_exists.return_value = True
            with patch('pathlib.Path.is_file') as mock_is_file:
                mock_is_file.return_value = True
                with patch('pathlib.Path.stat') as mock_stat:
                    mock_stat.side_effect = PermissionError("Permission denied")
                    
                    info = get_file_info('/root/protected_file')
                    self.assertEqual(info['type'], 'permission_error')
                    self.assertIn('error', info)
    
    def test_main_with_files(self):
        """Testar execução principal com arquivos."""
        test_args = ['size.py', self.test_file]
        
        with patch('sys.argv', test_args):
            with patch('sys.stdout') as mock_stdout:
                with patch('sys.exit') as mock_exit:
                    main()
                    
                    # Verificar se a saída foi impressa
                    self.assertTrue(mock_stdout.write.called)
                    mock_exit.assert_called_with(0)
    
    def test_main_with_directories(self):
        """Testar execução principal com diretórios."""
        test_args = ['size.py', self.test_dir]
        
        with patch('sys.argv', test_args):
            with patch('sys.stdout') as mock_stdout:
                with patch('sys.exit') as mock_exit:
                    main()
                    
                    self.assertTrue(mock_stdout.write.called)
                    mock_exit.assert_called_with(0)
    
    def test_main_with_nonexistent_file(self):
        """Testar execução principal com arquivo inexistente."""
        test_args = ['size.py', '/nonexistent/file.txt']
        
        with patch('sys.argv', test_args):
            with patch('sys.stderr') as mock_stderr:
                with patch('sys.exit') as mock_exit:
                    main()
                    
                    # Verificar se o erro foi impresso no stderr
                    self.assertTrue(mock_stderr.write.called)
                    mock_exit.assert_called_with(1)
    
    def test_main_no_arguments(self):
        """Testar execução sem argumentos."""
        test_args = ['size.py']
        
        with patch('sys.argv', test_args):
            with patch('sys.stderr') as mock_stderr:
                with patch('sys.exit') as mock_exit:
                    main()
                    
                    self.assertTrue(mock_stderr.write.called)
                    mock_exit.assert_called_with(1)
    
    def test_main_help_flag(self):
        """Testar flag de ajuda."""
        test_args = ['size.py', '--help']
        
        with patch('sys.argv', test_args):
            with patch('sys.stdout') as mock_stdout:
                with patch('sys.exit') as mock_exit:
                    main()
                    
                    self.assertTrue(mock_stdout.write.called)
                    mock_exit.assert_called_with(0)
    
    def test_main_version_flag(self):
        """Testar flag de versão."""
        test_args = ['size.py', '--version']
        
        with patch('sys.argv', test_args):
            with patch('sys.stdout') as mock_stdout:
                with patch('sys.exit') as mock_exit:
                    main()
                    
                    self.assertTrue(mock_stdout.write.called)
                    mock_exit.assert_called_with(0)
    
    def test_main_multiple_files(self):
        """Testar múltiplos arquivos."""
        # Criar segundo arquivo
        test_file2 = os.path.join(self.temp_dir, 'test_file2.txt')
        with open(test_file2, 'w') as f:
            f.write('x' * 200)  # 200 bytes
        
        test_args = ['size.py', self.test_file, test_file2]
        
        with patch('sys.argv', test_args):
            with patch('sys.stdout') as mock_stdout:
                with patch('sys.exit') as mock_exit:
                    main()
                    
                    self.assertTrue(mock_stdout.write.called)
                    mock_exit.assert_called_with(0)

if __name__ == '__main__':
    unittest.main()
