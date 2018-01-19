//
//  ChatViewController.m
//  My_App
//
//  Created by apple on 15-1-4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatFrame.h"
#import "Chat.h"
#import "ChatCell.h"
#import "ASIFormDataRequest.h"
#import "SecondViewController.h"
#import "SRWebSocket.h"

@interface ChatViewController ()<SRWebSocketDelegate>

@end

@implementation ChatViewController
{
    NSString *service_id;
    NSString *content1;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系客服";
    self.view.backgroundColor=[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:242/255.0f];
    _allChatFrame = [[NSMutableArray alloc]init];
    [self createBackBtn];
//    myTimer =   [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(functionTimer) userInfo:nil repeats:YES];
    //****************************聊天信息******************************//
    if (UIDeviceHao>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+10, ScreenFrame.size.width, ScreenFrame.size.height-64-49-10) style:UITableViewStylePlain];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.myTableView.backgroundColor=[UIColor lightGrayColor];
    self.myTableView.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:242/255.0f];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.allowsSelection = NO;
    self.myTableView.showsVerticalScrollIndicator= NO;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.myTableView];
    //  单击事件键盘收起
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [self.myTableView addGestureRecognizer:singleTapGestureRecognizer3];
    // 右滑事件
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backRealBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];
    //*****************************聊天框*******************************//
    imgBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenFrame.size.height - 49-64, ScreenFrame.size.width, 49)];
    imgBG.backgroundColor = [UIColor whiteColor];
    imgBG.userInteractionEnabled = YES;
    [self.view addSubview:imgBG];
    // 边框图片
    UIImageView *imgTextField = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6.5, ScreenFrame.size.width-90, 36)];
    imgTextField.layer.borderWidth = 1;
    imgTextField.layer.borderColor = [[UIColor orangeColor] CGColor];
    imgTextField.userInteractionEnabled = YES;
    [imgBG addSubview:imgTextField];
    // 聊天输入文本框
    self.chatTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, 200, 36)];
    self.chatTextField.placeholder = @"请输入聊天信息";
    self.chatTextField.font = [UIFont systemFontOfSize:14];
    self.chatTextField.delegate = self;
    [imgTextField addSubview:self.chatTextField];
    // 发送按钮 tag=101
    UIButton *btnSendOut = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSendOut.frame = CGRectMake(ScreenFrame.size.width-65, 6.5, 54, 36);
    CALayer *lay2 = btnSendOut.layer;
    [lay2 setMasksToBounds:YES];
    [lay2 setCornerRadius:5.0f];
    btnSendOut.tag = 101;
    btnSendOut.backgroundColor = [UIColor orangeColor];
    [btnSendOut setTitle:@"发  送" forState:UIControlStateNormal];
    btnSendOut.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnSendOut addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imgBG addSubview:btnSendOut];
    // 单例键盘出现隐藏的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 提示lable
    //[SYObject failedPrompt:@"暂不支持发表情"];
}
// tablebar的返回按钮

// 返回按钮事件
-(void)backRealBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createBackBtn{
    UIButton *button = [LJControl backBtn];
    [button addTarget:self action:@selector(backRealBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem =bar;
}

// 定时器方法
-(void)functionTimer{
    // 刷新tableview的请求发起
    NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FIRST_URL,CHAT_BUYER_REFRESH_URL]];
    request_1=[ASIFormDataRequest requestWithURL:url3];
    NSArray * fileContent2=[MyUtil returnLocalUserFile];
    [request_1 setPostValue:[fileContent2 objectAtIndex:3] forKey:@"user_id"];
    [request_1 setPostValue:[fileContent2 objectAtIndex:1] forKey:@"token"];
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    [request_1 setPostValue:sec.detail_id forKey:@"goods_id"];
    [request_1 setRequestHeaders:[LJControl requestHeaderDictionary]];
    request_1.tag = 102;
    request_1.delegate = self;
    [request_1 setDidFailSelector:@selector(urlRequestFailedChat:)];
    [request_1 setDidFinishSelector:@selector(urlRequestSucceededChat:)];
    [request_1 startAsynchronous];
}
-(void)createTableView
{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrame.origin.y+10, ScreenFrame.size.width, ScreenFrame.size.height-64-49-10) style:UITableViewStylePlain];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.myTableView.backgroundColor=[UIColor lightGrayColor];
    self.myTableView.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:242/255.0f];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.allowsSelection = NO;
    self.myTableView.showsVerticalScrollIndicator= NO;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.myTableView];
    //  单击事件键盘收起
    UITapGestureRecognizer *singleTapGestureRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappear)];
    [singleTapGestureRecognizer3 setNumberOfTapsRequired:1];
    [self.myTableView addGestureRecognizer:singleTapGestureRecognizer3];
    // 右滑事件
    UISwipeGestureRecognizer *rightSwipeGestureRecognizerSMytableview = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backRealBtnClicked)];
    rightSwipeGestureRecognizerSMytableview.direction = UISwipeGestureRecognizerDirectionRight;
    [self.myTableView addGestureRecognizer:rightSwipeGestureRecognizerSMytableview];

}
#pragma mark- ASIrequest
// 请求成功
-(void)urlRequestSucceededChat:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"聊天页面数据返回=============dicBig==============:%@",dicBig);
        if (dicBig) {
            NSArray *arr = [dicBig objectForKey:@"datas"];
            if (arr.count != 0) {
                // 增加数据源
                NSArray *array = [dicBig objectForKey:@"datas"];
                NSString *content = [[array objectAtIndex:0] objectForKey:@"content"];
                // 转换时间格式
                NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                NSDate *date = [NSDate date];
                fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
                NSString *time = [fmt stringFromDate:date];
                // 不知道是什么标记
                TTType = 1;
                // 数据源赋值方法
                [self addMessageWithContent:content time:time];
                // 2、刷新表格
                [self.myTableView reloadData];
                // 3、滚动至当前行
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allChatFrame.count-1  inSection:0];
                [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                // 4、清空文本框内容
                self.chatTextField.text = nil;
            }
        }
    }
}
// 请求失败
-(void)urlRequestFailedChat:(ASIFormDataRequest *)request{
    [SYObject failedPrompt:@"网络请求失败"];
}
// 键盘收起事件
-(void)disappear{
    [_chatTextField resignFirstResponder];
}
// 发送按钮点击事件
-(void)btnClicked:(UIButton *)btn
{
    if (btn.tag == 101)
    {
        // 文本框未输入内容点击弹出提示
        if(self.chatTextField.text.length == 0){
            [SYObject failedPrompt:@"消息内容不能为空"];
        }else{
            // 有文本内容
            NSArray *arr = [NSArray arrayWithObjects:@"😄",@"😃",@"😀",@"😊",@"☺️",@"😉",@"😍",@"😘",@"😚",@"😗",@"😙",@"😜",@"😝",@"😛",@"😳",@"😁",@"😔",@"😌",@"😒",@"😞",@"😣",@"😢",@"😂",@"😭",@"😪",@"😥",@"😰",@"😅",@"😓",@"😩",@"😫",@"😨",@"😱",@"😠",@"😡",@"😤",@"😖",@"😆",@"😋",@"😷",@"😎",@"😴",@"😵",@"😲",@"😟",@"😦",@"😧",@"😈",@"👿",@"😮",@"😬",@"😐",@"😕",@"😯",@"😶",@"😇",@"😏",@"😑",@"👲",@"👳",@"👮",@"👷",@"💂",@"👶",@"👦",@"👧",@"👨",@"👩",@"👴",@"👵",@"👱",@"👼",@"👸",@"😺",@"😸",@"😻",@"😽",@"😼",@"🙀",@"😿",@"😹",@"😾",@"👹",@"👺",@"🙈",@"🙉",@"🙊",@"💀",@"👽",@"💩",@"🔥",@"✨",@"🌟",@"💫",@"💥",@"💢",@"💦",@"💧",@"💤",@"💨",@"👂",@"👀",@"👃",@"👅",@"👄",@"👍",@"👎",@"👌",@"👊",@"✊",@"✌️",@"👋",@"✋",@"👐",@"👆",@"👇",@"👉",@"👈",@"🙌",@"🙏",@"☝️",@"👏",@"💪",@"🚶",@"🏃",@"💃",@"👫",@"👪",@"👬",@"👭",@"💏",@"💑",@"👯",@"🙆",@"🙅",@"💁",@"🙋",@"💆",@"💇",@"💅",@"👰",@"🙎",@"🙍",@"🙇",@"🎩",@"👑",@"👒",@"👟",@"👞",@"👡",@"👠",@"👢",@"👕",@"👔",@"👚",@"👗",@"🎽",@"👖",@"👘",@"👙",@"💼",@"👜",@"👝",@"👛",@"👓",@"🎀",@"🌂",@"💄",@"💛",@"💛",@"💜",@"💙",@"💚",@"❤️",@"💔",@"💗",@"💓",@"💕",@"💖",@"💞",@"💘",@"💌",@"💋",@"💍",@"💎",@"👤",@"👤",@"👥",@"💬",@"👣",@"💭",@"🐶",@"🐺",@"🐱",@"🐭",@"🐹",@"🐰",@"🐸",@"🐯",@"🐨",@"🐻",@"🐷",@"🐽",@"🐮",@"🐗",@"🐵",@"🐒",@"🐴",@"🐑",@"🐘",@"🐼",@"🐧",@"🐦",@"🐤",@"🐥",@"🐣",@"🐔",@"🐍",@"🐢",@"🐛",@"🐝",@"🐜",@"🐞",@"🐌",@"🐙",@"🐠",@"🐟",@"🐬",@"🐳",@"🐋",@"🐄",@"🐏",@"🐀",@"🐃",@"🐅",@"🐇",@"🐉",@"🐎",@"🐐",@"🐓",@"🐕",@"🐖",@"🐁",@"",@"🐂",@"🐲",@"🐡",@"🐊",@"🐫",@"🐪",@"🐆",@"🐈",@"🐩",@"🐾",@"💐",@"🌸",@"🌷",@"🍀",@"🌹",@"🌻",@"🌺",@"🍁",@"🍃",@"🍂",@"🌿",@"🌾",@"🍄",@"🌵",@"🌴",@"🌲",@"🌳",@"🌰",@"🌱",@"🌼",@"🌞",@"🌝",@"🌚",@"🌑",@"🌒",@"🌓",@"🌔",@"🌕",@"🌖",@"🌗",@"🌘",@"🌜",@"🌛",@"🌙",@"🌍",@"🌎",@"🌏",@"🌋",@"🌌",@"🌠",@"⭐️",@"☀️",@"⛅️",@"☁️",@"⚡️",@"☔️",@"❄️⛄️",@"🌀",@"🌁",@"🌈",@"🌊",@"🎍",@"💝",@"🎎",@"🎒",@"🎓",@"🎏",@"🎆",@"🎇",@"🎐",@"🎑",@"🎃",@"👻",@"🎅",@"🎄",@"🎁",@"🎋",@"🎉",@"🎊",@"🎈",@"🎌",@"🔮",@"🎥",@"📷",@"📹",@"📼",@"💿",@"📀",@"💽",@"💾",@"💻",@"📱",@"☎️",@"📞",@"📟",@"📠",@"📡",@"📺",@"📻",@"🔊",@"🔉",@"🔈",@"🔇",@"🔔",@"🔕",@"📢",@"📣",@"⏳",@"⌛️",@"⏰",@"⌚️",@"🔓",@"🔒",@"🔏",@"🔐",@"🔑",@"🔎",@"💡",@"🔦",@"🔆",@"🔅",@"🔌",@"🔍",@"🔋",@"🛁",@"🛀",@"🚿",@"🚽",@"🔧",@"🔩",@"🔨",@"🚪",@"🚬",@"💣",@"🔫",@"🔪",@"💊",@"💉",@"💰",@"💴",@"💵",@"💷",@"💶",@"💳",@"💸",@"📲",@"📧",@"📥",@"📤",@"✉️",@"📩",@"📨",@"📯",@"📫",@"📪",@"📬",@"📭",@"📮",@"📦",@"📝",@"📄",@"📃",@"📑",@"📊",@"📈",@"📉",@"📜",@"📋",@"📅",@"📆",@"📇",@"📁",@"📂",@"✂️",@"📌",@"📎",@"✒️",@"✏️",@"📏",@"📐",@"📕",@"📗",@"📘",@"📙",@"📓",@"📔",@"📔",@"📒",@"📚",@"📖",@"🔖",@"📛",@"🔬",@"🔭",@"📰",@"🎨",@"🎬",@"🎤",@"🎧",@"🎼",@"🎵",@"🎶",@"🎹",@"🎻",@"🎺",@"🎷",@"🎸",@"👾",@"🎮",@"🃏",@"🎴",@"🀄️",@"🎲",@"🎯",@"🏈",@"🏀",@"⚽️",@"⚾️",@"🎾",@"🎱",@"🏉",@"🏉",@"⛳️",@"🎳",@"🚵",@"🚴",@"🏁",@"🏇",@"🏆",@"🎿",@"🏂",@"🏊",@"🏄",@"🎣",@"☕️",@"🍵",@"🍶",@"🍼",@"🍺",@"🍻",@"🍸",@"🍹",@"🍷",@"🍴",@"🍕",@"🍔",@"🍟",@"🍗",@"🍖",@"🍝",@"🍛",@"🍤",@"🍱",@"🍲",@"🍦",@"🍨",@"🍢",@"🍣",@"🍥",@"🍡",@"🍧",@"🎂",@"🍳",@"🍙",@"🍘",@"🍞",@"🍰",@"🍪",@"🍩",@"🍚",@"🍜",@"🍮",@"🍫",@"🍬",@"🍭",@"🍯",@"🍎",@"🍏",@"🍊",@"🍋",@"🍒",@"🍇",@"🍉",@"🍓",@"🍑",@"🍈",@"🍌",@"🍐",@"🍍",@"🍠",@"🍆",@"🍅",@"🏠",@"🏡",@"🏫",@"🏢",@"🏣",@"🏥",@"🏦",@"🏪",@"🏩",@"🏨",@"💒",@"⛪️",@"🏬",@"🏤",@"🌇",@"🌆",@"🏯",@"🏰",@"⛺️",@"🏭",@"🗼",@"🗾",@"🎠",@"🚣",@"⚓️",@"🎡",@"🗻",@"🌄",@"🌅",@"🌃",@"🗽",@"🌉",@"⛲️",@"🎢",@"🚢",@"⛵️",@"🚤",@"🚀",@"✈️",@"💺",@"🚁",@"🚂",@"🚊",@"🚉",@"🚞",@"🚆",@"🚄",@"🚅",@"🚈",@"🚇",@"🚝",@"🚋",@"🚃",@"🚎",@"🚌",@"🚍",@"🚙",@"🚘",@"🚗",@"🚕",@"🚖",@"🚛",@"🚚",@"🚨",@"🚓",@"🚔",@"🚒",@"🚑",@"🚐",@"🚐",@"🚲",@"🚡",@"🚟",@"🚠",@"🚜",@"💈",@"🚏",@"🎫",@"🚦",@"🚥",@"⚠️",@"🚧",@"🔰",@"⛽️",@"🏮",@"🎰",@"♨️",@"🗿",@"🎪",@"🎭",@"📍",@"🚩",@"🇯🇵",@"🇰🇷",@"🇩🇪",@"🇨🇳",@"🇺🇸",@"🇫🇷",@"🇪🇸",@"🇮🇹",@"🇷🇺",@"🇬🇧",@"1⃣",@"2⃣",@"3⃣",@"4⃣",@"5⃣",@"6⃣",@"7⃣",@"8⃣",@"9⃣",@"0⃣",@"🔟",@"🔢",@"#⃣",@"🔣",@"⬆️",@"⬇️",@"⬅️",@"➡️",@"🔠",@"🔡",@"🔤",@"↗️",@"↖️",@"↘️",@"↙️",@"↔️",@"↕️",@"🔄",@"◀️",@"▶️",@"🔼",@"🔽",@"↩️",@"↪️",@"ℹ️",@"⏪",@"⏩",@"⏫",@"⏬",@"⤵️",@"⤴️",@"🆗",@"🔀",@"🔀",@"🔁",@"🔂",@"🆕",@"🆙",@"🆒",@"🆓",@"🆖",@"📶",@"🎦",@"🈁",@"🈯️",@"🈳",@"🈵",@"🈴",@"🈲",@"🉐",@"🈹",@"🈺",@"🈶",@"🈚️",@"🚻",@"🚹",@"🚺",@"🚼",@"🚾",@"🚰",@"🚮",@"🅿️",@"♿️",@"🚭",@"🈷",@"🈸",@"🈂",@"Ⓜ️",@"🛂",@"🛄",@"🛅",@"🛃",@"🉑",@"㊙️",@"㊗️",@"🆑",@"🆘",@"🆔",@"🚫",@"🔞",@"📵",@"🚯",@"🚱",@"🚳",@"🚷",@"🚸",@"⛔️",@"✳️",@"❇️",@"❎",@"✅",@"✴️",@"💟",@"🆚",@"📳",@"📴",@"🅰",@"🅱",@"🆎",@"🅾",@"💠",@"➿",@"♻️",@"♈️",@"♉️",@"♊️",@"♋️♋️",@"♌️",@"♎️",@"♏️",@"♐️",@"♑️",@"♒️",@"♓️",@"⛎",@"🔯",@"🏧",@"💹",@"💲",@"💱",@"©",@"®",@"™",@"❌",@"‼️",@"⁉️",@"❗️",@"❓",@"❕",@"❔",@"⭕️",@"🔝",@"🔚",@"🔙",@"🔛",@"🔜",@"🔃",@"🕛",@"🕧",@"🕐",@"🕜",@"🕑",@"🕝",@"🕒",@"🕞",@"🕓",@"🕟",@"🕔",@"🕠",@"🕕",@"🕖",@"🕗",@"🕘",@"🕙",@"🕚",@"🕡",@"🕢",@"🕣",@"🕤",@"🕥",@"🕦",@"✖️",@"➕",@"➖",@"➗",@"♠️",@"♥️",@"♣️",@"♦️",@"💮",@"💯",@"✔️",@"☑️",@"🔘",@"🔗",@"➰",@"〰",@"〽️",@"🔱",@"◼️",@"◻️",@"◾️",@"◽️",@"▪️",@"▫️",@"🔺",@"🔲",@"🔳",@"⚫️",@"⚪️",@"🔴",@"🔵",@"🔻",@"⬜️",@"⬛️",@"🔶",@"🔷",@"🔸",@"🔹", nil];
            // 判断是否发现上诉表情符号
            BOOL existBool = NO;
            for(NSString *str in arr){
                NSRange substr = [self.chatTextField.text rangeOfString:str];
                if (substr.location != NSNotFound) {
                    // 如果有表情写入，标记为yes
                    existBool = YES;
                    break;
                }
            }
            if (existBool == NO) {
               
                
                if (!service_id) {
                    NSString *errStr = @"用户未登录";
                    [SYObject failedPrompt:errStr];
                    return;
                }
                NSDictionary *dict = @{
                                       @"type":@"user",//固定
                                       @"service_id":service_id,//商家ID
                                       @"content":self.chatTextField.text,//聊天信息
                                       @"user_id":[SYObject currentUserID]
                                       };
                
                    [self send:dict];
               
                // 转换时间格式
                NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                NSDate *date = [NSDate date];
                fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
                NSString *time = [fmt stringFromDate:date];
                    
                TTType = 0;
                
                // 数据源赋值方法
                [self addMessageWithContent:self.chatTextField.text time:time];
                // 2、刷新表格
                [self.myTableView reloadData];
                // 3、滚动至当前行
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allChatFrame.count-1  inSection:0];
                [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                // 4、清空文本框内容
                self.chatTextField.text = nil;
   
                
            }
            
        }
        
    }else
    {
        _chatTextField.text = @"";
        [SYObject failedPrompt:@"暂不支持发表情"];
    }
 
}

// 请求成功返回数据，上传聊天内容成功
-(void)my1_urlRequestSucceeded:(ASIFormDataRequest *)request{
    int statuscode2 = [request responseStatusCode];
    if (statuscode2 == 200) {
        NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"我是上传的内容=========dicBig：%@",dicBig);
        if (dicBig) {
            // 1、增加数据源
            NSArray *array = [dicBig objectForKey:@"datas"];
            if (array.count != 0){
                NSString *content = [[array objectAtIndex:0] objectForKey:@"content"];
                // 设置时间格式
                NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
                NSDate *date = [NSDate date];
                fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
                NSString *time = [fmt stringFromDate:date];
                // 0表示数据上传
                TTType = 0;
                [self addMessageWithContent:content time:time];
                // 2、刷新表格
                [self.myTableView reloadData];
                // 3、滚动至当前行
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allChatFrame.count-1  inSection:0];
                [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                // 4、清空文本框内容
                self.chatTextField.text = nil;
            }
        }
    }
}
// 上传聊天内容失败
-(void)my1_urlRequestFailed:(ASIFormDataRequest *)request{

    [SYObject failedPrompt:@"网络请求失败"];
}
#pragma - mark 键盘上移
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        imgBG.transform = CGAffineTransformMakeTranslation(0, ty);
        self.myTableView.frame = CGRectMake(0, ScreenFrame.origin.y + 10, ScreenFrame.size.width, ScreenFrame.size.height-49-51+ty);
    }];
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        imgBG.transform = CGAffineTransformIdentity;
        self.myTableView.frame = CGRectMake(0, ScreenFrame.origin.y + 10, ScreenFrame.size.width, ScreenFrame.size.height-64-49);
    }];
}
#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    ChatFrame *mf = [[ChatFrame alloc] init];
    Chat *msg = [[Chat alloc] init];
    msg.content = content;
    msg.time = time;
    // 0时是我自己发言,用自己的头像
    if (TTType == 0) {
        msg.type = ChatTypeMe;
        msg.icon = @"myself.png";
    }else{
        msg.type = ChatTypeOther;
        msg.icon = @"other.png";
    }
    mf.chat = msg;
    [_allChatFrame addObject:mf];
}
#pragma mark - tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_allChatFrame.count != 0) {
        return _allChatFrame.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if (cell == nil) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    if (_allChatFrame.count != 0){
        cell.chatFrame = _allChatFrame[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_allChatFrame.count != 0) {
        return [_allChatFrame[indexPath.row] cellHeight];
    }
    return [_allChatFrame[indexPath.row] cellHeight];
}
#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
   
    //开启定时器固定方法之一
    [myTimer setFireDate:[NSDate distantPast]];
    [super viewWillAppear:YES];
    [self getNet];
    
}
#pragma mark - websocket代理方法
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    webSocket.delegate = nil;

    NSLog(@"已断开连接reason%@code%ldwasclean:%d",reason,(long)code,wasClean);
    
}
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    NSLog(@"出错了!错误信息:%@",[error localizedDescription]);
}
//收到消息
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSString *jsonString = message;
    NSData *json = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:NULL];
    NSLog(@"聊天信息%@",dict);
    
      NSString *content = [dict objectForKey:@"content"];
      //替换空格
      content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    if ([content rangeOfString:@"<div></div>"].location != NSNotFound)
    {
        NSArray *ary=[content componentsSeparatedByString:@"<div></div>"];
       content1=ary[0];
     
    }else
    {
        content1=content;
    
    }
    
    // 转换时间格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:date];
    // 判断是用户还是商家
    if ([[dict objectForKey:@"send_from"]isEqualToString:@"user"])
    {
        TTType = 0;
    }else
    {
        TTType = 1;
    }
        // 数据源赋值方法
        [self addMessageWithContent:content1 time:time];
        // 2、刷新表格
        [self.myTableView reloadData];
        // 3、滚动至当前行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allChatFrame.count-1  inSection:0];
        [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        // 4、清空文本框内容
        self.chatTextField.text = nil;
       NSString *chatlog_id=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
       NSDictionary *d = @{
                           @"type":@"service",//固定
                           @"chatlog_id":chatlog_id
                           
                           };
       [self send:d];
  
}
-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Web Socket开启成功!");
    NSString *lowerToken = [[SYObject currentToken]lowercaseString];
    if (!service_id) {
        NSString *errStr = @"没有service_id";
        [SYObject failedPrompt:errStr];
        return;
    }
    NSDictionary *dict = @{
                           @"type":@"user",//固定
                           @"service_id":service_id,
                           @"token":lowerToken,//本地token(转换成小写)
                           @"user_id":[SYObject currentUserID]
                           
                           };
    [self send:dict];
}
-(void)send:(NSDictionary *)dict{
    //转json,发送验证信息给服务器
    NSError *err;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
    NSString *jsonString = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
    if (err) {
        NSLog(@"发送参数出错:%@",[err localizedDescription]);
        return;
    }
    if (!json) {
        NSLog(@"json转换失败");
        return;
    }
    if (socket.readyState == SR_OPEN) {
        [socket send:jsonString];
    }else {
        [SYObject failedPrompt:@"请检查网络连接!"];
    }
}
#pragma mark - 初始化请求
//列表页初始化
-(void)setupSocket{
    NSString *token = [SYObject currentToken];
    if (token) {
        if (socket != nil) {
            socket.delegate = nil;
            [socket close];
        }
        NSString *str = [FIRST_URL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        NSString *urlStr = [NSString stringWithFormat:@"ws://%@/websocket",str];
        NSURL *url = [NSURL URLWithString:urlStr];
        SRWebSocket *webSocket = [[SRWebSocket alloc]initWithURL:url];
        socket = webSocket;
        webSocket.delegate = self;
        [webSocket open];
    }
}
-(void)getNet
{
    SecondViewController *sec = [SecondViewController sharedUserDefault];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",FIRST_URL,CHAT_BUYER_SEND_URL];

    NSDictionary *par = @{
                          @"user_id":[SYObject currentUserID],
                          @"token":[SYObject currentToken],
                          @"goods_id":sec.detail_id
                          };
    [[Requester managerWithHeader]POST:urlStr parameters:par success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * resultDict = responseObject;
        NSInteger code=[resultDict[@"code"] integerValue];
        if(code ==60001)
        {
            NSLog(@"聊天%@",resultDict);
            NSDictionary *dic=[resultDict objectForKey:@"data"];
           service_id=[NSString stringWithFormat:@"%@",[dic objectForKey:@"service_id"]];
            [self setupSocket];
                      
        }else
        {
            [SYObject failedPrompt:@"请求失败"];
            
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SYObject failedPrompt:@"请求失败"];
         NSLog(@"%@",[error localizedDescription]);
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [request_1 clearDelegatesAndCancel];
    [request3 clearDelegatesAndCancel];
    [socket close];
}
//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    //关闭定时器
    [myTimer invalidate];
    myTimer = nil;
    [super viewDidDisappear:YES];
}
@end
