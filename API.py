import requests
import json
from config import APIconf

'''Абстрактный класс для наследования API'''
class API:
    pass

'''Класс для подключения к API HH'''
class HeadHunterAPI(API):
    @staticmethod
    def get_emp() -> list[dict]:
        return [
            {
                'id': emp_id,
                'name': requests.get(f'https://api.hh.ru/employers/{emp_id}').json().get('name'),
                'url': requests.get(f'https://api.hh.ru/employers/{emp_id}').json().get('alternate_url')
            }
            for emp_id in APIconf.get('emps') if emp_id is not None
        ]

    @staticmethod
    def get_vacancies():
        return json.loads(requests.get(f'https://api.hh.ru/vacancies?text=&only_with_salary=true&employer_id={"&employer_id=".join(APIconf.get("emps"))}').content.decode())['items']