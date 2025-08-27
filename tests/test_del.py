#!/usr/bin/env python3

import unittest
import os
import tempfile
import shutil
import subprocess
from io import StringIO

class TestDelScript(unittest.TestCase):
    
    def setUp(self):
        # Criar diretório temporário para testes
        self.test_dir = tempfile.mkdtemp()
        self.original_cwd = os.getcwd()
        os.chdir(self.test_dir)
        self.script_path = os.path.join(os.path.dirname(__file__), '..', 'src', 'del.py')
    
    def tearDown(self):
        # Voltar ao diretório original e limpar
        os.chdir(self.original_cwd)
        shutil.rmtree(self.test_dir)
    
    def run_del_script(self, args):
        """Executa o script del.py com os argumentos fornecidos"""
        cmd = ['python3', self.script_path] + args
        result = subprocess.run(cmd, capture_output=True, text=True)
        return result
    
    def test_delete_file(self):
        # Criar arquivo de teste
        test_file = "test_file.txt"
        with open(test_file, 'w') as f:
            f.write("test content")
        
        # Verificar que arquivo existe
        self.assertTrue(os.path.exists(test_file))
        
        # Executar o script
        result = self.run_del_script([test_file])
        
        # Verificar que arquivo foi deletado
        self.assertFalse(os.path.exists(test_file))
        self.assertEqual(result.returncode, 0)
    
    def test_delete_directory(self):
        # Criar diretório com arquivos
        test_dir = "test_directory"
        os.makedirs(test_dir)
        test_file = os.path.join(test_dir, "test.txt")
        
        with open(test_file, 'w') as f:
            f.write("test content")
        
        self.assertTrue(os.path.exists(test_dir))
        
        # Executar o script
        result = self.run_del_script([test_dir])
        
        self.assertFalse(os.path.exists(test_dir))
        self.assertEqual(result.returncode, 0)
    
    def test_file_not_found(self):
        # Testar arquivo que não existe
        result = self.run_del_script(['nonexistent.txt'])
        self.assertIn("not found", result.stderr)
        self.assertEqual(result.returncode, 0)  # Seu script não muda exit code em erro
    
    def test_no_arguments(self):
        # Testar sem argumentos
        result = self.run_del_script([])
        self.assertIn("Missing file argument", result.stderr)
        self.assertEqual(result.returncode, 1)  # Seu script usa exit(1) sem args

if __name__ == '__main__':
    unittest.main()
