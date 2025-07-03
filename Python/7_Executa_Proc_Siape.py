import pyodbc

conn_str = (
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=DB2021;'
    'DATABASE=MOVEDB;'
    'Trusted_Connection=yes;'
)

try:
    with pyodbc.connect(conn_str, timeout=600, autocommit=True) as conn:
        cursor = conn.cursor()
        cursor.execute("EXEC Siape")

        # Consome todos os result sets e libera a procedure para continuar
        while True:
            try:
                while cursor.fetchone():
                    pass
            except pyodbc.ProgrammingError:
                pass
            if not cursor.nextset():
                break

    print("Comando enviado e procedure executada com sucesso.")
except Exception as e:
    print(f"Erro ao enviar o comando: {e}")

