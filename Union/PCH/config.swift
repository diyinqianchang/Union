//
//  config.swift
//  Union
//
//  Created by 万联 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import Foundation

let APPDELEGATE = UIApplication.sharedApplication().delegate as! AppDelegate

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

let MAINCOLOR = UIColor(colorLiteralRed: 105/255.0, green: 149/255.0, blue: 246/255.0, alpha: 1);

let kDownLoadWidth:CGFloat = 60.0;
let kOffSet:CGFloat = kDownLoadWidth/2;

func RGB(r:CGFloat,g:CGFloat,b:CGFloat)->UIColor{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0);
}


/**
*
*  =Union_News=
*
*  Interface
*
**/


let kNews_ListURL = "http://box.dwstatic.com/apiNewsList.php?action=l&newsTag=%@&p=%@"

let News_PrettyPicturesURL = "http://box.dwstatic.com/apiAlbum.php?action=l&albumsTag=%@&p=%@"

let News_TopicURL  = "http://box.dwstatic.com/apiNewsList.php?action=topic&topicId=%@"

let News_LPLLiveURL  = "http://lol.duowan.com/1501/m_285071449546.html"

let News_LPLItegralURL  = "http://lol.duowan.com/1501/m_285071469977.html"

let News_WebViewURl  = "http://box.dwstatic.com/apiNewsList.php?action=d&newsId="

let News_PicturesURL = "http://box.dwstatic.com/apiAlbum.php?action=d&albumId="



/**
*
*  =Union_News=
*
*  Interface
*
*  ===END===
**/




/**
*
*  =Union_Video=
*
*  Interface
*
**/



//分类视图URL

let kUnion_Video_SortURL = "http://box.dwstatic.com/apiVideoesNormalDuowan.php?src=duowan&action=c&sk=&sn=&pn="

//最新视图URL

let kUnion_Video_NewURL = "http://box.dwstatic.com/apiVideoesNormalDuowan.php?src=duowan&action=l&sk=&pageUrl=&heroEnName=&tag=newest&p=%ld"

//分类中点击cell后URL

let kUnion_Video_URL = "http://box.dwstatic.com/apiVideoesNormalDuowan.php?v=117&action=l&p=%@&tag=%@&src=letv"

//视频搜索URL

let kUnion_Video_SearchURL = "http://box.dwstatic.com/apiVideoesNormalDuowan.php?searchKey=%@&p=%@&v=118&action=search"

//视频详情URL

let kUnion_VideoDetailsURL = "http://box.dwstatic.com/apiVideoesNormalDuowan.php?action=f&vid=%@"


/**
*
*  =Union_Video=
*
*  Interface
*
*  ===END===
**/


/**
*
*  =Union_Ency=
*
*  Interface
*
**/

//联盟百科菜单URL

let kUnion_EncyMenuURL = "http://box.dwstatic.com/apiToolMenu.php?category=database&v=117&OSType=iOS8.4&versionName=2.2.7"

//英雄列表URL

let kUnion_Ency_HeroListURL = "http://lolbox.duowan.com/phone/apiHeroes.php?type=%@"

//我的英雄列表URL

let kUnion_Ency_MyHeroListURL = "http://lolbox.duowan.com/phone/apiMyHeroes.php?serverName=%@&target=%@&v=108"

//英雄详情URL

let kUnion_Ency_HeroDetailsURL = "http://lolbox.duowan.com/phone/apiHeroDetail.php?heroName=%@"


//英雄 —— 英雄图片 (PNG)

//http://img.lolbox.duowan.com/champions/英雄名_120x120.jpg

let kUnion_Ency_HeroImageURL = "http://img.lolbox.duowan.com/champions/%@_120x120.jpg"

//英雄 —— 英雄技能图片 (PNG)

//http://img.lolbox.duowan.com/abilities/Yasuo_E_64x64.png

let KUnion_Ency_HeroSkillImageURL = "http://img.lolbox.duowan.com/abilities/%@_64x64.png"

//英雄详情-英雄出装列表URL

let kUnion_Ency_HeroDetails_EquipSelectURL = "http://db.duowan.com/lolcz/img/ku11/api/lolcz.php?v=108&OSType=iOS8.3&championName=%@&limit=7"

//英雄详情-英雄排行TOP10URL

let kUnion_Ency_HeroDetails_RankingURL = "http://lolbox.duowan.com/phone/heroTop10PlayersNew.php?hero=%@"

//英雄详情-英雄皮肤URL

let kUnion_Ency_HeroDetails_PiFuURL = "http://box.dwstatic.com/apiHeroSkin.php?hero=%@"


//英雄详情-英雄配音URL

let kUnion_Ency_HeroDetails_MusicURL = "http://box.dwstatic.com/sounds/%@/%@.mp3"





//装备分类列表URL

let kUnion_Equip_Type_ListURL = "http://lolbox.duowan.com/phone/apiZBCategory.php"

//装备列表URL

let kUnion_Equip_ListURl = "http://lolbox.duowan.com/phone/apiZBItemList.php?tag=%@"

//装备图片URL

let kUnion_Equip_ListImageURL = "http://img.lolbox.duowan.com/zb/%ld_64x64.png"

//装备详情URL

let kUnion_Equip_DetailsURL = "http://lolbox.duowan.com/phone/apiItemDetail.php?id=%ld"



//符文URL

let kUnion_AllRunesURL = "http://lolbox.duowan.com/phone/apiRunes.php"

//符文图片URL

//http://img.lolbox.duowan.com/runes/bl_2_3.png

//http://img.lolbox.duowan.com/runes/Img_等级.png

let kUnion_RunesImageURL = "http://img.lolbox.duowan.com/runes/%@_%ld.png"








/**
*
*  =Union_Ency=
*
*  Interface
*
*  ===END===
**/





/**
*
*  =Union_MyUnion=
*
*  Interface
*
**/

//全部服务器URL

let kAllServersURL = "http://lolbox.duowan.com/phone/apiServers.php";


//添加召唤师URL

let kUnion_MyUion_AddSummonerURL = "http://lolbox.duowan.com/phone/apiCheckUser.php?action=getPlayersInfo&serverName=%@&target=%@"

//我的信息URL

let kUnion_MyUnion_URL = "http://zdl.mbox.duowan.com/phone/playerDetailNew.php?sn=%@&target=%@&v=108&OSType=iOS8.4&versionName=2.2.5"

//召唤师头像URL

let kUnion_MyUnion_IconURL = "http://img.lolbox.duowan.com/profileIcon/profileIcon%@.jpg"

/**
*
*  =Union_MyUnion=
*
*  Interface
*
*  ===END===
**/

