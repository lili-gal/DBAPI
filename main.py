from API import HeadHunterAPI
from DBManager import DBManager
from config import APIconf

''' Функция пользовательского интерфейса'''
def user_interface():
    while True:
        answer = input('Какая информация Вас интересует?\n1. Список компаний\n2. Список всех вакансий\n'
                       '3. Средняя ЗП по вакансиям\n4. Вакансии с ЗП выше средней\n5. Поиск вакансий по ключевому слову\n')
        if answer == '1':
            print(dbm.get_companies_and_vacancies_count())
            break
        elif answer == '2':
            print(dbm.get_all_vacancies())
            break
        elif answer == '3':
            print(dbm.get_avg_salary())
            break
        elif answer == '4':
            print(dbm.get_vacancies_with_higher_salary())
            break
        elif answer == '5':
            ans = input('Введите ключевое слово: ')
            print(dbm.get_vacancies_with_keyword(ans))
            break


if __name__ == '__main__':
    params = {
        'host': APIconf.get('DBSettings')['host'],
        'dbname': APIconf.get('DBSettings')['dbname'],
        'user': APIconf.get('DBSettings')['user'],
        'password': APIconf.get('DBSettings')['password'],
        'port': APIconf.get('DBSettings')['port']
    }
    data = HeadHunterAPI.get_vacancies()
    emps = HeadHunterAPI.get_emp()
    dbm = DBManager(host=params['host'], dbname=params['dbname'], user=params['user'], password=params['password'], port=params['port'])
    dbm.delete_tables()
    dbm.create_tables()
    dbm.insert_emps_to_db(emps)
    dbm.insert_data_to_db(data)
    user_interface()

