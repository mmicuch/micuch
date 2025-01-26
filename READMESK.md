# SLOVESNKY

> [!IMPORTANT]
> PRE SPUSTENIE TOHTO PROJEKTU JE POTREBNÝ FUNKČNÝ DOCKER

## AKO SPUSTIŤ

1. Premenujte súbor `.env-dist` na `.env` a zmeňte si heslá pre svoju databázu
2. Naimportujte databázu zo súboru `docker\build\mariadb\cms.sql` alebo si vytvorte vlastnú
3. Spustite príkaz `docker-compose up` pomocou vášho súboru `docker-compose.yaml`
4. Otvorte terminál pre váš kontajner `node`  
5. Spustite príkaz `npm install`, aby sa nainštalovali všetky balíčky, na ktorých kód závisí  
6. Spustite príkaz `node cli/set_password admin "password"`, kde "password" má byť heslo pre admin prihlásenie na stránku  
7. Spustite príkaz `node cli/set_password user "password"`, kde "password" má byť heslo pre prihlásenie bežného používateľa na stránku  

## EXISTUJÚ TRI ÚROVNE POUŽÍVATEĽOV
### NEPRIHLÁSENÝ POUŽÍVATEĽ
- Vidí všetky nadchádzajúce udalosti  
- Môže triediť nadchádzajúce udalosti podľa dátumu, názvu a regiónu  
- Vidí detailnú stránku udalosti  
- Môže komentovať udalosti s akýmkoľvek používateľským menom, okrem tých, ktoré sú už obsadené  

### PRIHLÁSENÝ POUŽÍVATEĽ
- Vidí všetky nadchádzajúce udalosti  
- Môže triediť nadchádzajúce udalosti podľa dátumu, názvu a regiónu  
- Vidí detailnú stránku udalosti  
- Môže komentovať udalosti iba so svojim registrovaným používateľským menom  

### ADMIN POUŽÍVATEĽ
- Vidí všetky nadchádzajúce udalosti  
- Môže triediť nadchádzajúce udalosti podľa dátumu, názvu a regiónu  
- Vidí detailnú stránku udalosti 
- Môže komentovať udalosti iba so svojim registrovaným používateľským menom  
- Môže vytvárať udalosti
- Môže upravovať udalosti
- Môže vymazávať komentáre  
- Vidí minulé udalosti
