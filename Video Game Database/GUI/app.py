from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient
from datetime import datetime

app= Flask(__name__)

client= MongoClient("mongodb://localhost:27017")
db= client["Videogame_Database"]


@app.route('/')
def home():
    Player= db["Player"].find()
    Weapon= db["Weapon"].find()
    Armor= db["Armor"].find()
    Consumable= db["Consumable"].find()
    Item= db["Item"].find()
    Map_Location= db["Map_Location"].find()
    Skills= db["Skill"].find()
    Mission= db["Mission"].find()
    return render_template("index.html", players=Player, weapons= Weapon, armors= Armor, consumables=Consumable, items= Item, locations= Map_Location, missions= Mission, skills= Skills)

@app.route('/player', methods= ["POST", "GET"])
def player():
    s_Player= db["Player"].find({"mastery.weapon": {"$gte": 26}}).sort("mastery.weapon", -1)
    a_Player= db["Player"].find({"mastery.weapon": {"$gte": 21, "$lte": 25}}).sort("mastery.weapon", -1)
    b_Player= db["Player"].find({"mastery.weapon": {"$gte": 16, "$lte": 20}}).sort("mastery.weapon", -1)
    c_Player= db["Player"].find({"mastery.weapon": {"$gte": 11, "$lte": 15}}).sort("mastery.weapon", -1)
    d_Player= db["Player"].find({"mastery.weapon": {"$gte": 6, "$lte": 10}}).sort("mastery.weapon", -1)
    f_Player= db["Player"].find({"mastery.weapon": {"$gte": 0, "$lte": 5}}).sort("mastery.weapon", -1)
    
    if request.method == "POST":
        dropdown= request.form["searchby-dropdown"]
        searchbar= request.form["lookup"].lower()
        comp_range= request.form["range"]
        srtd= request.form["sort"]
        order= request.form["sad"]
        print(f"This is d: {comp_range}")
        if searchbar.isdigit():
                searchbar= int(searchbar)
        if dropdown == "All":
            if srtd == "none":
                query= db["Player"].find({})
            else:
                query= db["Player"].find({}).sort(srtd, int(order))
        else:
            if srtd == "none":
                if comp_range=="None":  
                    query= db["Player"].find({dropdown : searchbar})
                else:
                     query=db["Player"].find({dropdown: {comp_range: int(searchbar)}})
            else:
                if comp_range=="None":
                    query= db["Player"].find({dropdown : searchbar}).sort(srtd, int(order))
                else:
                    query= db["Player"].find({dropdown: {comp_range: int(searchbar)}}).sort(srtd, int(order))

        return render_template("collectionPages/Player.html", sPlayer= s_Player, aPlayer= a_Player, bPlayer= b_Player, cPlayer= c_Player, dPlayer= d_Player, fPlayer= f_Player, methods=["POST", "GET"],  a= query)
    
    elif request.method == "GET":
        print("Request is not POST")
        return render_template("collectionPages/Player.html", sPlayer= s_Player, aPlayer= a_Player, bPlayer= b_Player, cPlayer= c_Player, dPlayer= d_Player, fPlayer= f_Player, methods= ["POST", "GET"], a= None)


@app.route('/weapon', methods= ["POST", "GET"])
def weapon():
    s_Weapon= db["Weapon"].find({"damage": {"$gte": 180}}).sort("damage", -1)
    a_Weapon= db["Weapon"].find({"damage": {"$gte": 131, "$lte": 179}}).sort("damage", -1)
    b_Weapon= db["Weapon"].find({"damage": {"$gte": 71, "$lte": 130}}).sort("damage", -1)
    c_Weapon= db["Weapon"].find({"damage": {"$gte": 21, "$lte": 70}}).sort("damage", -1)
    f_Weapon= db["Weapon"].find({"damage": {"$gte": 0, "$lte": 20}}).sort("damage", -1)

    if request.method == "POST":
        dropdown= request.form["searchby-dropdown"]
        searchbar= request.form["lookup"].lower()
        comp_range= request.form["range"]
        srtd= request.form["sort"]
        order= request.form["sad"]
        print(f"This is d: {comp_range}")
        if searchbar.isdigit():
                searchbar= int(searchbar)
        if dropdown == "All":
            if srtd == "none":
                query= db["Weapon"].find({})
            else:
                query= db["Weapon"].find({}).sort(srtd, int(order))
        else:
            if srtd == "none":
                if comp_range=="None":  
                    query= db["Weapon"].find({dropdown : searchbar})
                else:
                     query=db["Weapon"].find({dropdown: {comp_range: int(searchbar)}})
            else:
                if comp_range=="None":
                    query= db["Weapon"].find({dropdown : searchbar}).sort(srtd, int(order))
                else:
                    query= db["Weapon"].find({dropdown: {comp_range: int(searchbar)}}).sort(srtd, int(order))
        return render_template("collectionPages/Weapon.html", sWeapon= s_Weapon, aWeapon= a_Weapon, bWeapon= b_Weapon, cWeapon= c_Weapon, fWeapon= f_Weapon, methods= ["POST", "GET"], a= query)
    elif request.method == "GET":
                return render_template("collectionPages/Weapon.html", sWeapon= s_Weapon, aWeapon= a_Weapon, bWeapon= b_Weapon, cWeapon= c_Weapon, fWeapon= f_Weapon, methods= ["POST", "GET"], a=None)

@app.route('/armor', methods= ["POST", "GET"])
def armor():
    s_Armor= db["Armor"].find({"resistance": {"$gte": 50}}).sort("resistance", -1)
    head_Armor= db["Armor"].find({"bodypart": "head"}).sort("resistance", -1)
    torso_Armor= db["Armor"].find({"bodypart": "torso"}).sort("resistance", -1)
    arms_Armor= db["Armor"].find({"bodypart": "arms"}).sort("resistance", -1)
    leg_Armor= db["Armor"].find({"bodypart": "legs"}).sort("resistance", -1)
    feet_Armor= db["Armor"].find({"bodypart": "feet"}).sort("resistance", -1)

    if request.method == "POST":
        dropdown= request.form["searchby-dropdown"]
        searchbar= request.form["lookup"].lower()
        comp_range= request.form["range"]
        srtd= request.form["sort"]
        order= request.form["sad"]
        print(f"This is d: {comp_range}")
        if searchbar.isdigit():
                searchbar= int(searchbar)
        if dropdown == "All":
            if srtd == "none":
                query= db["Armor"].find({})
            else:
                query= db["Armor"].find({}).sort(srtd, int(order))
        else:
            if srtd == "none":
                if comp_range=="None":  
                    query= db["Armor"].find({dropdown : searchbar})
                else:
                     query=db["Armor"].find({dropdown: {comp_range: int(searchbar)}})
            else:
                if comp_range=="None":
                    query= db["Armor"].find({dropdown : searchbar}).sort(srtd, int(order))
                else:
                    query= db["Armor"].find({dropdown: {comp_range: int(searchbar)}}).sort(srtd, int(order))
        return render_template("collectionPages/Armor.html", sArmor= s_Armor, hArmor= head_Armor, tArmor= torso_Armor, aArmor= arms_Armor, lArmor= leg_Armor, fArmor= feet_Armor, methods= ["POST", "GET"], a= query)
    elif request.method == "GET":
                return render_template("collectionPages/Armor.html", sArmor= s_Armor, hArmor= head_Armor, tArmor= torso_Armor, aArmor= arms_Armor, lArmor= leg_Armor, fArmor= feet_Armor, methods= ["POST", "GET"], a=None)


@app.route('/consumable', methods= ["POST", "GET"])
def consumable():
    s_Consumable= db["Consumable"].find({"type" : "stat up"}).sort("level", -1)
    r_Consumable= db["Consumable"].find({"type" : "resistance"}).sort("level", -1)
    resr_Consumable= db["Consumable"].find({"type" : "resurrection"}).sort("level", -1)
    reg_Consumable= db["Consumable"].find({"type" : "regeneration"}).sort("level", -1)
    t_Consumable= db["Consumable"].find({"type" : "tactical"}).sort("level", -1)

    if request.method == "POST":
        dropdown= request.form["searchby-dropdown"]
        searchbar= request.form["lookup"].lower()
        comp_range= request.form["range"]
        srtd= request.form["sort"]
        order= request.form["sad"]
        print(f"This is d: {comp_range}")
        if searchbar.isdigit():
                searchbar= int(searchbar)
        if dropdown == "All":
            if srtd == "none":
                query= db["Consumable"].find({})
            else:
                query= db["Consumable"].find({}).sort(srtd, int(order))
        else:
            if srtd == "none":
                if comp_range=="None":  
                    query= db["Consumable"].find({dropdown : searchbar})
                else:
                     query=db["Consumable"].find({dropdown: {comp_range: int(searchbar)}})
            else:
                if comp_range=="None":
                    query= db["Consumable"].find({dropdown : searchbar}).sort(srtd, int(order))
                else:
                    query= db["Consumable"].find({dropdown: {comp_range: int(searchbar)}}).sort(srtd, int(order))
        return render_template("collectionPages/Consumable.html", sConsumable= s_Consumable, rConsumable= r_Consumable, resrConsumable= resr_Consumable, regConsumable= reg_Consumable, tConsumable= t_Consumable, methods= ["POST", "GET"], a= query)
    elif request.method == "GET":
                return render_template("collectionPages/Consumable.html", sConsumable= s_Consumable, rConsumable= r_Consumable, resrConsumable= resr_Consumable, regConsumable= reg_Consumable, tConsumable= t_Consumable, methods= ["POST", "GET"], a=None)


@app.route('/item', methods= ["POST", "GET"])
def item():
    all_item= db["Item"].find().sort("item_name", 1)
    q_Item= db["Item"].find({"quest_item" : True}).sort("item_name", 1)
    u_Item= db["Item"].find({"used_in_crafting" : True}).sort("item_name", 1)
    c_Item= db["Item"].find({"craftable" : True}).sort("item_name", 1)

    if request.method == "POST":
        dropdown= request.form["searchby-dropdown"]
        searchbar= request.form["lookup"].lower()
        comp_range= request.form["range"]
        srtd= request.form["sort"]
        order= request.form["sad"]
        print(f"This is d: {comp_range}")
        if searchbar.isdigit():
                searchbar= int(searchbar)
        if dropdown == "All":
            if srtd == "none":
                query= db["Item"].find({})
            else:
                query= db["Item"].find({}).sort(srtd, int(order))
        else:
            if srtd == "none":
                if comp_range=="None":  
                    query= db["Item"].find({dropdown : searchbar})
                else:
                     query=db["Item"].find({dropdown: {comp_range: int(searchbar)}})
            else:
                if comp_range=="None":
                    query= db["Item"].find({dropdown : searchbar}).sort(srtd, int(order))
                else:
                    query= db["Item"].find({dropdown: {comp_range: int(searchbar)}}).sort(srtd, int(order))
        return render_template("collectionPages/Item.html", aItem= all_item, qItem= q_Item, uItem= u_Item, cItem= c_Item, methods= ["POST", "GET"], a= query)
    elif request.method == "GET":
                return render_template("collectionPages/Item.html", aItem= all_item, qItem= q_Item, uItem= u_Item, cItem= c_Item, methods= ["POST", "GET"], a=None)


@app.route('/location', methods= ["POST", "GET"])
def location():
    g_Location= db["Map_Location"].find({"region": "enchanted forest"}).sort("has_savepoint", -1)
    w_Location= db["Map_Location"].find({"region": "mystical archipelago"}).sort("has_savepoint", -1)
    v_Location= db["Map_Location"].find({"region": "volcanic wastelands"}).sort("has_savepoint", -1)
    i_Location= db["Map_Location"].find({"region": "icy bay"}).sort("has_savepoint", -1)
    d_Location= db["Map_Location"].find({"region": "silent desert"}).sort("has_savepoint", -1)
    f_Location= db["Map_Location"].find({"region": "astral rift"}).sort("has_savepoint", -1)

    if request.method == "POST":
        dropdown= request.form["searchby-dropdown"]
        searchbar= request.form["lookup"].lower()
        comp_range= request.form["range"]
        srtd= request.form["sort"]
        order= request.form["sad"]
        print(f"This is d: {comp_range}")
        if searchbar.isdigit():
                searchbar= int(searchbar)
        if dropdown == "All":
            if srtd == "none":
                query= db["Map_Location"].find({})
            else:
                query= db["Map_Location"].find({}).sort(srtd, int(order))
        else:
            if srtd == "none":
                if comp_range=="None":  
                    query= db["Map_Location"].find({dropdown : searchbar})
                else:
                     query=db["Map_Location"].find({dropdown: {comp_range: int(searchbar)}})
            else:
                if comp_range=="None":
                    query= db["Map_Location"].find({dropdown : searchbar}).sort(srtd, int(order))
                else:
                    query= db["Map_Location"].find({dropdown: {comp_range: int(searchbar)}}).sort(srtd, int(order))
        return render_template("collectionPages/Location.html", gLocation= g_Location, wLocation= w_Location, vLocation= v_Location, iLocation= i_Location, dLocation= d_Location, fLocation= f_Location, methods= ["POST", "GET"], a= query)
    elif request.method == "GET":
                return render_template("collectionPages/Location.html", gLocation= g_Location, wLocation= w_Location, vLocation= v_Location, iLocation= i_Location, dLocation= d_Location, fLocation= f_Location, methods= ["POST", "GET"], a=None)


@app.route('/skill', methods= ["POST", "GET"])
def skill():
    u_Skill= db["Skill"].find({"category" : "ultimate"}).sort("skill_name", 1)
    aoe_Skill= db["Skill"].find({"category" : "aoe"}).sort("skill_name", 1)
    att_Skill= db["Skill"].find({"category" : "attack"}).sort("skill_name", 1)
    def_Skill= db["Skill"].find({"category" : "defense"}).sort("skill_name", 1)
    mov_Skill= db["Skill"].find({"category" : "movement"}).sort("skill_name", 1)
    trap_Skill= db["Skill"].find({"category" : "trap"}).sort("skill_name", 1)

    if request.method == "POST":
        dropdown= request.form["searchby-dropdown"]
        searchbar= request.form["lookup"].lower()
        comp_range= request.form["range"]
        srtd= request.form["sort"]
        order= request.form["sad"]
        print(f"This is d: {comp_range}")
        if searchbar.isdigit():
                searchbar= int(searchbar)
        if dropdown == "All":
            if srtd == "none":
                query= db["Skill"].find({})
            else:
                query= db["Skill"].find({}).sort(srtd, int(order))
        else:
            if srtd == "none":
                if comp_range=="None":  
                    query= db["Skill"].find({dropdown : searchbar})
                else:
                     query=db["Skill"].find({dropdown: {comp_range: int(searchbar)}})
            else:
                if comp_range=="None":
                    query= db["Skill"].find({dropdown : searchbar}).sort(srtd, int(order))
                else:
                    query= db["Skill"].find({dropdown: {comp_range: int(searchbar)}}).sort(srtd, int(order))
        return render_template("collectionPages/Skill.html", uSkill= u_Skill, aoeSkill= aoe_Skill, attSkill= att_Skill, defSkill= def_Skill, movSkill= mov_Skill, trapSkill= trap_Skill, methods= ["POST", "GET"], a= query)
    elif request.method == "GET":
                return render_template("collectionPages/Skill.html", uSkill= u_Skill, aoeSkill= aoe_Skill, attSkill= att_Skill, defSkill= def_Skill, movSkill= mov_Skill, trapSkill= trap_Skill, methods= ["POST", "GET"], a=None)

@app.route('/mission', methods= ["POST", "GET"])
def mission():
    main_Mission= db["Mission"].find({"main_mission":True}).sort("main_mission", 1)
    side_Mission= db["Mission"].find({"main_mission":False}).sort("main_mission", 1)


    if request.method == "POST":
        dropdown= request.form["searchby-dropdown"]
        searchbar= request.form["lookup"].lower()
        comp_range= request.form["range"]
        srtd= request.form["sort"]
        order= request.form["sad"]
        print(f"This is d: {comp_range}")
        if searchbar.isdigit():
                searchbar= int(searchbar)
        if dropdown == "All":
            if srtd == "none":
                query= db["Mission"].find({})
            else:
                query= db["Mission"].find({}).sort(srtd, int(order))
        else:
            if srtd == "none":
                if comp_range=="None":  
                    query= db["Mission"].find({dropdown : searchbar})
                else:
                     query=db["Mission"].find({dropdown: {comp_range: int(searchbar)}})
            else:
                if comp_range=="None":
                    query= db["Mission"].find({dropdown : searchbar}).sort(srtd, int(order))
                else:
                    query= db["Mission"].find({dropdown: {comp_range: int(searchbar)}}).sort(srtd, int(order))
        return render_template("collectionPages/Mission.html", mMission= main_Mission, sMission= side_Mission, methods= ["POST", "GET"], a=query)
    elif request.method == "GET":
        return render_template("collectionPages/Mission.html", mMission= main_Mission, sMission= side_Mission, methods= ["POST", "GET"], a=None)

@app.route('/insert', methods= ["POST", "GET"])
def insert():
     if request.method == "POST":
        cc= request.form["selected"]
        allSkills= db["Skill"].find()
        allMissions= db["Mission"].find({"main_mission": False})
        allItems= db["Item"].find()
        allHead= db["Armor"].find({"bodypart": "head"})
        allTorso= db["Armor"].find({"bodypart": "torso"})
        allArms= db["Armor"].find({"bodypart": "arms"})
        allLegs= db["Armor"].find({"bodypart": "legs"})
        allFeet= db["Armor"].find({"bodypart": "feet"})
        allConsumables= db["Consumable"].find()
        allWeapons= db["Weapon"].find()
        allLocations= db["Map_Location"].find()
        inserted= request.form["insert-collection"]
        print(inserted)
        print(type(inserted))

        if inserted == "true":
            if cc == "Player":
                n= request.form["username"]
                ew= request.form["inventory.equipped.weapon"]
                es= request.form["inventory.equipped.skill"]
                ec= request.form["inventory.equipped.consumable"]
                eh= request.form["inventory.equipped.head"]
                et= request.form["inventory.equipped.torso"]
                ea= request.form["inventory.equipped.arms"]
                el= request.form["inventory.equipped.legs"]
                ef= request.form["inventory.equipped.feet"]
                bp= request.form.getlist("inventory.backpack")
                hp= request.form["health"]
                sp= request.form["stamina"]
                ar= request.form["armor"]
                wm= request.form["mastery.weapon"]
                sm= request.form["mastery.skill"]
                sv= request.form["savepoint.location"]
                if ew == "null":
                    ew= None
                if es == "null":
                    es= None
                if ec == "null":
                    ec= None
                if eh == "null":
                    eh= None
                if et == "null":
                    et= None
                if ea == "null":
                    ea= None
                if el == "null":
                    el= None
                if ef == "null":
                    ef= None
                db["Player"].insert_one({
                    "username": n,
                    "inventory": {
                        "equipped": {
                            "weapon": ew,
                            "skill": es,
                            "consumable": ec,
                            "head": eh,
                            "torso":et,
                            "arms": ea,
                            "legs": el,
                            "feet": ef,
                        },
                        "backpack": bp
                    },
                    "health": int(hp),
                    "stamina": int(sp),
                    "armor": int(ar),
                    "mastery":{
                        "weapon": int(wm),
                        "skill": int(sm)
                    },
                    "savepoint":{
                        "location": sv,
                        "date": datetime.now()
                    }
                })
                print("Query has been run")
                return render_template("insert.html", methods=["POST", "GET"], cc= cc, skills= allSkills, missions= allMissions, items=allItems, head= allHead, torso= allTorso, arms= allArms, legs= allLegs, feet= allFeet, consumables= allConsumables, weapons= allWeapons, locations= allLocations, query_placed= f'db["Player"].insert_one(["username": {n},"inventory": ["equipped": ["weapon": {ew},"skill": {es},"consumable": {ec},"head": {eh},"torso":{et},"arms": {ea},"legs": {el},"feet": {ef},],"backpack": {bp},],"health": {int(hp)},"stamina": {int(sp)},"armor": {int(ar)},"mastery":["weapon": {int(wm)},"skill": {int(sm)},],"savepoint":["location": {sv},"date": {datetime.now()},]])')
            elif cc == "Weapon":
                n= request.form["weapon_name"]
                dg= request.form["damage"]
                lvl= request.form["level"]
                db["Weapon"].insert_one({"weapon_name": n, "damage": int(dg), "level": int(lvl)})
                print("query has been run")
                return render_template("insert.html", methods=["POST", "GET"], cc= cc, skills= allSkills, missions= allMissions, items=allItems, head= allHead, torso= allTorso, arms= allArms, legs= allLegs, feet= allFeet, consumables= allConsumables, weapons= allWeapons, locations= allLocations, query_placed= f"db['Weapon'].insert_one(['weapon_name': {n}, 'damage': {dg}, 'level': {lvl}])")
            elif cc == "Armor":
                n= request.form["armor_name"]
                rs= request.form["resistance"]
                bd= request.form["bodypart"]
                lvl= request.form["level"]
                db["Armor"].insert_one({"armor_name": n, "resistance": int(rs), "bodypart": bd, "level": int(lvl)})
                print("query has been run")
                return render_template("insert.html", methods=["POST", "GET"], cc= cc, skills= allSkills, missions= allMissions, items=allItems,  head= allHead, torso= allTorso, arms= allArms, legs= allLegs, feet= allFeet,  consumables= allConsumables, weapons= allWeapons, locations= allLocations, query_placed= f"db['Armor'].insert_one(['armor_name': {n}, 'resistance': {int(rs)}, 'bodypart': {bd}, 'level': {int(lvl)}])")
            elif cc == "Consumable":
                n= request.form["consumable_name"]
                ty= request.form["type"]
                lvl= request.form["level"]
                db["Consumable"].insert_one({"consumable_name": n, "type": ty, "level": int(lvl)})
                print("query has been run")
                return render_template("insert.html", methods=["POST", "GET"], cc= cc, skills= allSkills, missions= allMissions, items=allItems,  head= allHead, torso= allTorso, arms= allArms, legs= allLegs, feet= allFeet,  consumables= allConsumables, weapons= allWeapons, locations= allLocations, query_placed= f"db['Consumable'].insert_one(['consumable_name': {n}, 'type': {ty}, 'level': {int(lvl)}])")
            elif cc == "Item":
                n= request.form["item_name"]
                ty= request.form["quest_item"]
                lvl= request.form["used_in_crafting"]
                cf= request.form["craftable"]
                r= request.form.getlist("recipe")
                db["Item"].insert_one({"item_name": n, "quest_item": bool(ty), "used_in_crafting": bool(lvl), "craftable": bool(cf), "recipe": r})
                print("query has been run")
                return render_template("insert.html", methods=["POST", "GET"], cc= cc, skills= allSkills, missions= allMissions, items=allItems,  head= allHead, torso= allTorso, arms= allArms, legs= allLegs, feet= allFeet,  consumables= allConsumables, weapons= allWeapons, locations= allLocations, query_placed= f"db['Item'].insert_one(['item_name': {n}, 'quest_item': {bool(ty)}, 'used_in_crafting': {bool(lvl)}, 'craftable': {bool(cf)}, 'recip': {r}])")
            elif cc == "Location":
                n= request.form["location_name"]
                ty= request.form["region"]
                lvl= request.form["has_savepoint"]
                db["Map_Location"].insert_one({"location_name": n, "region": ty, "has_savepoint": bool(lvl)})
                print("query has been run")
                return render_template("insert.html", methods=["POST", "GET"], cc= cc, skills= allSkills, missions= allMissions, items=allItems,  head= allHead, torso= allTorso, arms= allArms, legs= allLegs, feet= allFeet,  consumables= allConsumables, weapons= allWeapons, locations= allLocations, query_placed= f"db['Map_Location'].insert_one(['location_name': {n}, 'region': {ty}, 'has_savepoint': {bool(lvl)}])")
            elif cc == "Skill":
                n= request.form["skill_name"]
                ty= request.form["category"]
                lvl= request.form.getlist("prerequisite_skills")
                db["Skill"].insert_one({"skill_name": n, "category": ty, "prerequisite_skills": lvl})
                print("query has been run")
                return render_template("insert.html", methods=["POST", "GET"], cc= cc, skills= allSkills, missions= allMissions, items=allItems,  head= allHead, torso= allTorso, arms= allArms, legs= allLegs, feet= allFeet,  consumables= allConsumables, weapons= allWeapons, locations= allLocations, query_placed= f"db['Skill'].insert_one(['skill_name': {n}, 'category': {ty}, 'prerequisite_skills': {lvl}])")
            elif cc == "Mission":
                n= request.form["mission_name"]
                lvl= request.form.getlist("prerequisite_missions")
                db["Mission"].insert_one({"mission_name": n, "main_mission": False, "prerequisite_missions": lvl})
                print("query has been run")
                return render_template("insert.html", methods=["POST", "GET"], cc= cc, skills= allSkills, missions= allMissions, items=allItems,  head= allHead, torso= allTorso, arms= allArms, legs= allLegs, feet= allFeet,  consumables= allConsumables, weapons= allWeapons, locations= allLocations, query_placed= f"db['Mission'].insert_one(['mission_name': {n}, 'main_mission': False, 'prerequisite_missions': {lvl}])")
        
        return render_template("insert.html", methods=["POST", "GET"], cc= cc, skills= allSkills, missions= allMissions, items=allItems,  head= allHead, torso= allTorso, arms= allArms, legs= allLegs, feet= allFeet,  consumables= allConsumables, weapons= allWeapons, locations= allLocations)

     if request.method == "GET":
        return render_template("insert.html", methods=["POST", "GET"], cc= "Please choose a collection to add to") 

if __name__ == "__main__":
    app.run(debug=True)