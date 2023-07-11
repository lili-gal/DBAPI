    def create_tables(self):
        with self.conn.cursor() as cur:
            cur.execute("""
            CREATE TABLE IF NOT EXISTS companies (
                id INT PRIMARY KEY,
                name TEXT NOT NULL,
                url VARCHAR(150)
            );
            """)
            cur.execute("""
            CREATE TABLE IF NOT EXISTS vacancies (
            id INT PRIMARY KEY,
            name TEXT NOT NULL,
            company_id INT REFERENCES companies(id) ON DELETE CASCADE,
            salary_min INT,
            salary_max INT,
            url VARCHAR(150) NOT NULL
            );
            """)
            self.conn.commit()
    '''Функция удаления таблиц'''
    def delete_tables(self):
        with self.conn.cursor() as cur:
            cur.execute("DROP TABLE IF EXISTS vacancies;")
            cur.execute("DROP TABLE IF EXISTS companies;")
            self.conn.commit()
    '''Функции для заполнения таблиц'''
    def insert_emps_to_db(self, emps):
        with self.conn.cursor() as cur:
            for emp in emps:
                cur.execute("""
                INSERT INTO companies (id, name, url)
                VALUES (%s, %s, %s);
                """, (emp['id'], emp['name'], emp['url']))
                self.conn.commit()

    def insert_data_to_db(self, data):
        with self.conn.cursor() as cur:
            for vacancy in data:
                cur.execute("""
                INSERT INTO vacancies (id, name, company_id, salary_min, salary_max, url)
                VALUES (%s, %s, %s, %s, %s, %s);
                """, (vacancy['id'], vacancy['name'], vacancy['employer']['id'], vacancy['salary']['from'],
                      vacancy['salary']['to'], vacancy['alternate_url']))
                self.conn.commit()
    '''получает список всех компаний и количество вакансий у каждой компании.'''
    def get_companies_and_vacancies_count(self):
        with self.conn.cursor() as cur:
            cur.execute("""
            SELECT companies.name, COUNT(vacancies.id)
            FROM companies
            JOIN vacancies ON companies.id = vacancies.company_id
            GROUP BY companies.name;
            """)
            return cur.fetchall()
            cursor.close()
            conn.close()
    '''получает список всех вакансий с указанием названия компании, названия вакансии и зарплаты и ссылки на вакансию'''
    def get_all_vacancies(self):
        with self.conn.cursor() as cur:
            cur.execute("""
            SELECT companies.name, vacancies.name, vacancies.salary_min,  vacancies.salary_max, vacancies.url
            FROM vacancies
            JOIN companies ON vacancies.company_id = companies.id;
            """)
            return cur.fetchall()
            cursor.close()
            conn.close()
    '''получает среднюю зарплату по вакансиям'''
    def get_avg_salary(self):
        with self.conn.cursor() as cur:
            cur.execute("""
            SELECT AVG(salary_max) AS SalaryAVG FROM vacancies;
            """)
            return cur.fetchall()
            cursor.close()
            conn.close()
    '''получает список всех вакансий, у которых зарплата выше средней по всем вакансиям'''
    def get_vacancies_with_higher_salary(self):
        with self.conn.cursor() as cur:
            cur.execute("""
            SELECT vacancies.name, vacancies.salary_max
            FROM vacancies
            WHERE salary_max > (SELECT AVG(salary_max) FROM vacancies);
            """)
            return cur.fetchall()
            cursor.close()
            conn.close()
    '''получает список всех вакансий, в названии которых содержатся переданные в метод слова'''
    def get_vacancies_with_keyword(self, word):
        with self.conn.cursor() as cur:
            cur.execute(f"""
            SELECT vacancies.name, vacancies.salary_max
            FROM vacancies
            WHERE name LIKE '%{word}%';
            """)
            return cur.fetchall()
            cursor.close()
            conn.close()