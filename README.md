# Trabalho Unidade 3 Grafos

## Desenvolvimento

### Pré-requisitos

- [Cargo 1.90.0](https://rust-lang.org/learn/get-started/)
- [Texlive (full)](https://tug.org/texlive/) e Texlive-lang-portuguese: pode ser
  encontrado nos gerenciadores de pacote comuns.
- [Docker](https://www.docker.com/): Alternativa para compilar o $\LaTeX$, caso
  não queira instalar o `texlive`
- [Graphviz](https://www.graphviz.org/download/): Para converter os arquivos
  `.dot` em imagens `.png`

#### Nix

Se você possuí nix, basta executar o seguinte comando para sincronizar as
dependências:

```terminal
nix develop
```

### Compilação e testes

É possível fazer isso via cargo ou Makefile.

- **cargo**

  ```bash
  # Compila o projeto
  cargo br

  # Executa um binário específico
  cargo rr --bin transgenetic

  # Executa testes unitários
  cargo tr

  # Verifica o código usando o clippy
  cargo clippy

  # Formata o código
  cargo fmt
  ```

- **Makefile**

  ```bash
  $ make help
  Available targets:
    build           Builds a given algorithm with release mode and a given instance, e.g. `make build ALGO=genetic INSTANCE=001`
    build-test      Builds the cargo project
    check           Performs a cargo check with release mode
    clean           Cleans the generated artifact
    clippy          Runs clippy
    fmt_check       Check if the code is formatted
    fmt             Formats the code
    help            Show this help message
    run             Runs a given algorithm with a given instance and params, e.g. `make run-instance INSTANCE=1 ALGO=transgenetic PARAMS="100 50 42"`
    test            Runs all tests
  ```

#### $\LaTeX$

Na pasta `latex/`:

```bash
# Exibe receitas disponíveis
make help

# Compila pdf no diretório output/
make

# Limpa arquivos auxiliares
make clean

# Limpa todos os arquivos (incluindo pdf)
make distclean

# Limpa e compila novamente
make rebuild
```

#### $\LaTeX$ com Docker

```bash
# Cria a imagem docker
docker build -t latex-compiler latex/

# Compila a imagem e executa o container criando o pdf.
# --rm automaticamente deleta o container e o volume
docker run --rm latex-compiler > main.pdf
```

Existe uma imagem compilada em `vleema/latex-compiler` (não garantimos que
esteja atualizada). Podes substituir `docker build...` por

```bash
docker pull vleema/latex-compiler:latest
```
