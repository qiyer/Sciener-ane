# TTLockSDK

SDK2.1
1.增加对三代锁IC卡的支持


SDK2.0.1
1. 调用的蓝牙接口中的管理员密码、约定数和aeskey的数据类型由NSData改成NSString!!!!!!!!(方便上传和请求）
2. 原管理员密码 password 改为adminPS  原约定数 key 改为lockkey


SDK2.0
1. 调用的接口名称全部更新（如果之前使用过sdk,请对照 TTLockDemo中  表iOS  SDK接口列表）
2. 重置(生成)键盘密码的回调，不返回进度，成功后会把生成的数据返回，如需使用需上传到服务端。
3. 增加了对三代锁的支持
4. 修复了之前sdk一些已知的bug，同时对其进行了优化。
5. 电量：通过getPower获取的电量值如果为-1，说明没有获取到电量，而不是电量为-1


使用方法 可以参照TTLockDemo ！！！！