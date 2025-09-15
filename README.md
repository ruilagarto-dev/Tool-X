# Tool-X

Tool-X simplifies using Raspberry Pi with simple commands for files and folders, making tasks easier and faster even for beginners.


## Available Commands

### ``del`` - Delete files or directories
Permanently removes files or directories from the system.

#### Exemplos:
```bash
del file.txt
del old_folder/
del *.tmp
del file1.txt file2.txt
```
#### Options:
- `-h, --help` - Show help message
- `-v, --version` - Show version information.

<br>

### ``open`` - Open image files
View images directly in the terminal (supported formats: JPG, JPEG, PNG, GIF, BMP, PPM, PGM)

#### Examples:
```bash
open image.jpg
open -d photo.png  # Show details without opening
open image1.png image2.jpg
```
#### Options:
- `-d, --details` - Show file details without opening.
- `-h, --help`- Show help message.
- `-v, --version` - Show version information.

<br>

### `size` - Show size of files or folders
Displays the size of files or directories in human-readable format (recursive for folders).

#### Examples:
```bash
size file.txt
size folder/
size file1.txt file2.txt folder/
```

#### Options:
- `-h, --help` - Show help message.
- `-v, --version` - Show verison information.


### `tree` - Display directory structure in tree format
Shows directory hierarchy with option to include file sizes.

#### Examples:
```bash
tree /path/to/directory
tree --no-size 
```
#### Options:
- `--no-size` - Show tree without size information.
- `-h, --help` - Show help message.
- `-v, --version` - Show verison information.

## Installation

```bash
cd Tool-X/scripts/
bash install.sh
```

## Desinstalar
```bash
cd Tool-X/scripts/
bash uninstall.sh
```


## Project Structure

```
Tool-X/
├── README.md
├── scripts/
│   ├── install.sh
|   └── uninstall.sh
├── tests/
│   ├── run_tests.sh
|   ├── test_del.py
|   ├── test_open.py
|   ├── test_size.py
|   └── test_tree.py
└── src/
    ├── tool-x
    ├── del
    ├── open
    ├── size
    └── tree

```