# Tool-X

Tool-X simplifica o uso do Raspberry Pi com comandos simples para arquivos e pastas, tornando as tarefas mais simples e rápidas mesmo para iniciantes.

## Comandos Disponíveis

### ``del`` - Apaga arquivos ou diretórios
Remove permanentemente arquivos ou diretorios do sistema.

Exemplos:
```bash
del arquivo.txt
del pasta_arquivo/
del *.temp
del arquivo1.txt arquivo2.txt
```
Opções:
- `-h, --help` - Mostra mensagem de ajuda.
- `-v, --version` -Mostra informação de versão

<br>

### ``open`` - Abre arquivos de imagem
Visualiza imagens diretamente no terminal (formatos suportados: JPG, JPEG, PNG, GIF, BMP, PPM, PGM)

#### Exemplos:
```bash
open imagem.jpg
open -d foto.png
```
#### Opçóes:
- `-d, --details` - Mostra detalhes do arquivo sem abrir
- `-h, --help`- Mostra mensagem de ajuda.
- `-v, --version` - Mostra informação de versão.

<br>

### `size` - Mostra o tamanho de arquivos ou pastas
Exibe o tamanho de arquivos ou diretorios em formato legível (recursivo para pastas).

#### Exemplos
```bash
size arquivo.txt
size pasta/
size arquivo1.txt arquivo2.txt
```

#### Opções:
- `-h, --help` - Mostra mensagem de ajuda.
