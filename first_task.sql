/*
    Задача 1

    Выгрузить из базы данных с использованием SQL-запроса информацию по следующим пользователям:

    • Ученики с годовых курсов ЕГЭ и ОГЭ

    Необходимые поля в итоговой выгрузке:
    
    • ID курса
    • Название курса
    • Предмет
    • Тип предмета
    • Тип курса
    • Дата старта курса
    • ID ученика
    • Фамилия ученика
    • Город ученика
    • Ученик не отчислен с курса
    • Дата открытия курса ученику
    • Сколько полных месяцев курса открыто у ученика
    • Число сданных ДЗ ученика на курсе
*/

SELECT
    cu.course_id AS "ID курса",
    c.name AS "Название курса",
    s.name AS "Предмет",                      
    s.project AS "Тип предмета",              
    ct.name AS "Тип курса",                   
    c.starts_at AS "Дата старта курса",       
    u.id AS "ID ученика",                     
    u.last_name AS "Фамилия ученика",         
    ci.name AS "Город ученика",               
    cu.active AS "Ученик не отчислен с курса",
    cu.created_at AS "Дата открытия курса ученику", 
    FLOOR(cu.available_lessons / c.lessons_in_month) AS "Сколько полных месяцев курса открыто у ученика", 
    COUNT(hd.id) AS "Число сданных ДЗ ученика на курсе" 
FROM
    course_users cu                               
JOIN
    users u ON cu.user_id = u.id                  
JOIN
    courses c ON cu.course_id = c.id              
JOIN
    subjects s ON c.subject_id = s.id             
JOIN
    course_types ct ON c.course_type_id = ct.id   
JOIN
    cities ci ON u.city_id = ci.id                
LEFT JOIN
    homework_done hd ON hd.user_id = u.id AND hd.homework_id IN (
        SELECT h.id
        FROM homework h
        JOIN lessons l ON h.lesson_id = l.id
        WHERE l.course_id = c.id
    )                                             
WHERE
    ct.name IN ('ЕГЭ', 'ОГЭ')                     
    AND cu.active = true                          
GROUP BY
    cu.course_id, c.name, s.name, s.project, ct.name, c.starts_at,
    u.id, u.last_name, ci.name, cu.active, cu.created_at, cu.available_lessons, c.lessons_in_month
ORDER BY
    cu.course_id, u.id;
