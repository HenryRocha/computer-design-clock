# Assembler

Assembler para a arquitetura criada para este projeto.

Regras básicas:

- Use `$` quando for fazer referência à um registrador (i.e. `$1` representa o registrador 1)
- Use a representação hexadecimal para indicar endereços e valores imediatos (i.e. `0x1` representa 1, `0x1a` representa 26)
- Para comentários no arquivo, inicie a linha com `;`

Para rodar, utilize o comando:

```bash
python3 assembler.py -i <input_file> -o <output_file>
```

Se necessário, observe o arquivo de entrada `example.nasm`.