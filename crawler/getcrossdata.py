# pip install requests
import requests
from seleniumbase import SB
from bs4 import BeautifulSoup
import json
import os
import time
import random

year = 109
def requestdata(url):
    time.sleep(random.randint(1, 2))
    with SB(uc=True,headless=True) as sb:
        sb.driver.uc_open_with_reconnect(url, 4)
        data = sb.driver.page_source
        #sb.driver.clear_session_storage()
        #sb.driver.quit()
    return data


def makesoup(response):
    soup = BeautifulSoup(response, features='html.parser')
    return soup


def getuniversity(soup):
    university_dict = {}

    # 找到所有包含大學名稱和連結的<a>標籤
    for a_tag in soup.find_all('a', href=True):
        # 確保<a>標籤內包含大學名稱並且連結不是空的
        if '大學' in a_tag.text and a_tag.text not in ['大學繁星', '大學個人申請', '大學個人申請', '大學甄選委員會',
                                                       '大學分發委員會', '大學考試中心']:
            university_name = a_tag.text.strip()
            university_link = a_tag['href']
            university_dict[university_name] = university_link

    return university_dict


def getspector(soup):
    sectors = {}
    for idx, _ in enumerate(soup.find_all(align="left")):
        if idx <= 1:
            pass
        elif idx % 2 == 0:
            sectors[str(_.a.text)] = _.a['href']
    return sectors


def getstudents(soup, url):
    conndict = {}
    url = url.replace('https://www.com.tw/cross/', "")
    for student in soup.find_all(colspan="4"):
        for sector in student.find_all(href=True):
            if '大學' in sector.text and sector['href'] != url:
                if sector['href'] not in conndict:
                    conndict[sector['href']] = 1
                else:
                    conndict[sector['href']] += 1

    return url, conndict


def main():
    if not os.path.exists("./cross/students.json"):
        os.mkdir("./cross")
    with open("./cross/students.json", "w") as f:
        json.dump(list([]), f)
    uni_url = f"https://www.com.tw/cross/university_list{year}.html"
    response = requestdata(uni_url)
    time.sleep(1)
    soup = makesoup(response)
    university_dict = getuniversity(soup)
    with open("./cross/university.json", "w", encoding='utf8') as f:
        json.dump(university_dict, f, ensure_ascii=False)
        print(university_dict)
    for key, val in university_dict.items():
        val = "https://www.com.tw/cross/" + val
        time.sleep(random.randint(2, 4))
        soup = makesoup(requestdata(val))
        sectors = getspector(soup)
        for i in range(3):
            if len(sectors) != 0:
                break
            time.sleep(random.randint(5, 7))
            soup = makesoup(requestdata(val))
            sectors = getspector(soup)
        else:
            with open("./cross/log.txt", "a") as f:
                f.write(f"Error: {key}\n")
            print(f"Error: {key}")
        with open(f"./cross/{key}.json", "w", encoding='utf8') as f:
            json.dump(sectors, f, ensure_ascii=False)

        with open("./cross/students.json", "r", encoding='utf8') as f:
            data = json.load(f)
        temp = []
        for sector in sectors.values():
            flag = False
            for dt in data:
                if sector in dt.keys():
                    flag = True
                    break
            if flag:
                print(f"pass {sector}")
                continue
            sector = "https://www.com.tw/cross/" + sector
            soup = makesoup(requestdata(sector))
            node, conn = getstudents(soup, sector)
            for i in range(3):
                if "music" in sector:
                    print(f"music pass {sector}")
                    with open("./cross/log.txt", "a") as f:
                        f.write(f"Error: {sector}\n")
                    break
                if len(conn) != 0:
                    break
                time.sleep(random.randint(5, 7))
                soup = makesoup(requestdata(sector))
                node, conn = getstudents(soup, sector)
                print(f"Retry {i + 1} times in {sector}...")
            else:
                print(f"Error: {sector}")
                with open("./cross/log.txt", "a") as f:
                    f.write(f"Error: {sector}\n")
                continue
            temp.append({node: conn})
            print(node, conn)
        data.extend(temp)
        with open("./cross/students.json", "w", encoding='utf8') as f:
            json.dump(data, f, ensure_ascii=False)
        print(f"{key} finished\n")


if __name__ == '__main__':
    main()

#%%
