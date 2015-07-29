# card-ios-version
iOS版本的瞎扯
### 提交fir需要注意
1. 在appdelegate修改checkNewUpdate方法的get 请求链接,如果是发布到企业的话，需要把链接参数修改为ComFirId，ComFirApiToken。如果是公司内部，则需要修改为InFirApiToken，InFirId。


### 上线appstore需注意
1.注视掉fir的版本更新，在appdelegate中    //检测版本更新
        [GCDQueue executeInGlobalQueue:^{
        
        [GCDQueue executeInMainQueue:^{
            [self checkNewUpdate];
        }];
    } afterDelaySecs:10];
注册此句代码
