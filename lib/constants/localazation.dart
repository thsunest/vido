import 'package:get/get.dart';
class Localization extends Translations {
    @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // 基础词汇
          'hello': 'Hello World',
          'title': 'My App',
          'language': 'Language',
          
          // 登录页面
          'welcome_login': 'Welcome to Login',
          'chinese': 'Chinese',
          'enter_username': 'Enter username',
          'enter_password': 'Enter password',
          'agree': 'Agree',
          'user_agreement': 'User Agreement',
          'login': 'Login',
          'login_success': 'Login successful',
          'login_failed': 'Login failed, please check your username and password',
          
          // 顶部栏
          'platform_terms': 'Platform Terms',
          
          // 左侧信息区
          'income': 'Income',
          'balance': 'Balance',
          'withdraw': 'Withdraw',
          'live_sessions': 'Live Sessions',
          'live_duration': 'Live Duration',
          'minutes': 'minutes',
          'viewer_count': 'Viewer Count',
          'scroll_message': 'Scroll message',
          'refresh': 'Refresh',
          'online_users': 'Online Users',
          
          // 直播控制
          'start_live': 'Start Live',
          'end_live': 'End Live',
          'live_title': 'Live Title',
          'enter_live_title': 'Enter live title',
          'live_category': 'Live Category',
          'select_live_category': 'Select live category',
          'video_device': 'Video Device',
          'audio_device': 'Audio Device',
          
          // 设置面板
          'screen_settings': 'Screen Settings',
          'charge_settings': 'Charge Settings',
          'tip_settings': 'Tip Settings',
          'course_settings': 'Course Settings',
          
          // 画面设置
          'mirror_flip': 'Mirror Flip',
          'screen_rotation': 'Screen Rotation',
          'skin_smoothing': 'Skin Smoothing',
          'whitening': 'Whitening',
          'eye_enlarging': 'Eye Enlarging',
          'face_thinning': 'Face Thinning',
          'mirror_enabled': 'Mirror flip enabled',
          'mirror_disabled': 'Mirror flip disabled',
          
          // 收费设置
          'enable_charging': 'Enable Charging',
          'per_session_charge': 'Per Session Charge',
          'time_based_charge': 'Time-based Charge',
          'enter_coins': 'Enter coins',
          'please_select': 'Please select',
          'coins_per_minute': '(Coins/minute)',
          'coin_amount_required': 'Coin amount cannot be empty',
          
          // 打赏设置
          'add_gift': 'Add Gift',
          'gift_added_success': 'Gift added successfully',
          'gift_add_failed': 'Failed to add gift',
          'gift_updated_success': 'Gift updated successfully',
          'gift_update_failed': 'Failed to update gift',
          'name_price_required': 'Name and price cannot be empty',
          'no_editing_gift': 'No gift being edited',
          'delete': 'Delete',
          
          // 互动消息
          'interactive_messages': 'Interactive Messages',
          'say_something': 'Say something',
          'send': 'Send',
          
          // 通用按钮
          'confirm': 'Confirm',
          'cancel': 'Cancel',
          'close': 'Close',
          'save': 'Save',
          'add': 'Add',
          'edit': 'Edit',
          'remove': 'Remove',
          'submit': 'Submit',
          'ok': 'OK',
          
          // 错误提示
          'error': 'Error',
          'success': 'Success',
          'failed': 'Failed',
          'exception': 'Exception',
          'network_error': 'Network Error',
          'unknown_error': 'Unknown Error',
          
          // 设备选择和媒体控制
          'microphone': 'Microphone',
          'volume': 'Volume',
          'camera': 'Camera',
          'no_device_found': 'No device found',
          'device_permission_denied': 'Device permission denied',
          
          // 用户管理
          'mute_user': 'Mute User',
          'unmute_user': 'Unmute User',
          'kick_user': 'Kick User',
          'user_muted': 'User muted',
          'user_unmuted': 'User unmuted',
          'user_kicked': 'User kicked',
          
          // 文件上传
          'upload_image': 'Upload Image',
          'upload_cover': 'Upload Cover',
          'file_upload_failed': 'File upload failed',
          'file_upload_success': 'File uploaded successfully',
          'select_file': 'Select File',
          
          // 系统操作
          'minimize': 'Minimize',
          'maximize': 'Maximize',
          'restore': 'Restore',
          'fullscreen': 'Fullscreen',
          'exit_fullscreen': 'Exit Fullscreen',
          
          // 直播间状态
          'live_room_url': 'Live Room URL',
          'room_id': 'Room ID',
          'live_status': 'Live Status',
          'broadcasting': 'Broadcasting',
          'not_broadcasting': 'Not Broadcasting',
          
          // 消息类型
          'system_message': 'System Message',
          'user_message': 'User Message',
          'gift_message': 'Gift Message',
          'join_message': 'joined the room',
          'leave_message': 'left the room',
          
          // 网络状态
          'connecting': 'Connecting...',
          'connected': 'Connected',
          'disconnected': 'Disconnected',
          'connection_failed': 'Connection Failed',
          'reconnecting': 'Reconnecting...',
          
          // 验证信息
          'field_required': 'This field is required',
          'invalid_format': 'Invalid format',
          'password_too_short': 'Password is too short',
          'username_too_short': 'Username is too short',
        },
        'zh_CN': {
          // 基础词汇
          'hello': '你好 世界',
          'title': '我的应用',
          'language': '语言',
          
          // 登录页面
          'welcome_login': '欢迎登录',
          'chinese': '中文',
          'enter_username': '请输入用户名',
          'enter_password': '请输入密码',
          'agree': '同意',
          'user_agreement': '《用户协议》',
          'login': '登录',
          'login_success': '登录成功',
          'login_failed': '登录失败,请检查您的用户名和密码',
          
          // 顶部栏
          'platform_terms': '平台条款',
          'tip': '提示音',

          // 左侧信息区
          'income': '收入',
          'balance': '余额',
          'withdraw': '提现',
          'live_sessions': '开播场次',
          'live_duration': '开播时长',
          'minutes': '分钟',
          'viewer_count': '观众人数',
          'scroll_message': '滚动消息滚动消息',
          'refresh': '刷新',
          'online_users': '在线用户',
          
          // 直播控制


          'click_to_start_live': '点击下方按钮开启直播',


          'start_live': '开始直播',
          'end_live': '结束直播',
          'live_title': '直播标题',
          'enter_live_title': '请输入直播标题',
          'live_category': '直播分类',
          'select_live_category': '请选择直播分类',
          'video_device': '视频设备',
          'audio_device': '音频设备',
          
          // 设置面板
          'screen_settings': '画面设置',
          'charge_settings': '收费设置',
          'tip_settings': '打赏设置',
          'course_settings': '课程设置',
          
          // 画面设置
          'mirror_flip': '镜像翻转',
          'screen_rotation': '屏幕旋转',
          'skin_smoothing': '磨皮',
          'whitening': '美白',
          'eye_enlarging': '大眼',
          'face_thinning': '瘦脸',
          'mirror_enabled': '已开启镜像翻转',
          'mirror_disabled': '已关闭镜像翻转',


        

          // 收费设置
          'enable_charging': '开启收费',
          'per_session_charge': '按场收费',
          'time_based_charge': '计时收费',
          'enter_coins': '请输入金币',
          'please_select': '请选择',
          'coins_per_minute': '（金币/分钟）',
          'coin_amount_required': '金币数量不能为空',
          
          // 打赏设置
          'add_gift': '添加',
          'gift_added_success': '礼物添加成功',
          'gift_add_failed': '添加礼物失败',
          'gift_updated_success': '礼物更新成功',
          'gift_update_failed': '更新礼物失败',
          'name_price_required': '名称和价格不能为空',
          'no_editing_gift': '没有正在编辑的礼物',
          'delete': '删除',
          
          // 互动消息
          'interactive_messages': '互动消息',
          'say_something': '说点什么',
          'send': '发送',
          
          // 通用按钮
          'confirm': '确定',
          'cancel': '取消',
          'close': '关闭',
          'save': '保存',
          'add': '添加',
          'edit': '编辑',
          'remove': '移除',
          'submit': '提交',
          'ok': '好的',
          'single_choice_upload': '单选上传',

          // 错误提示
          'error': '错误',
          'success': '成功',
          'failed': '失败',
          'exception': '异常',
          'network_error': '网络错误',
          'unknown_error': '未知错误',
          
          // 设备选择和媒体控制
          'microphone': '麦克风',
          'volume': '音量',
          'camera': '摄像头',
          'no_device_found': '未找到设备',
          'device_permission_denied': '设备权限被拒绝',
          
          // 用户管理
          'mute_user': '静音用户',
          'unmute_user': '取消静音',
          'kick_user': '踢出用户',
          'user_muted': '用户已静音',
          'user_unmuted': '用户已取消静音',
          'user_kicked': '用户已被踢出',
          
          // 文件上传
          'upload_image': '上传图片',
          'upload_cover': '上传封面',
          'file_upload_failed': '文件上传失败',
          'file_upload_success': '文件上传成功',
          'select_file': '选择文件',
          
          // 系统操作
          'minimize': '最小化',
          'maximize': '最大化',
          'restore': '还原',
          'fullscreen': '全屏',
          'exit_fullscreen': '退出全屏',
          
          // 直播间状态
          'live_room_url': '直播间链接',
          'room_id': '房间号',
          'live_status': '直播状态',
          'broadcasting': '正在直播',
          'not_broadcasting': '未在直播',
          
          // 消息类型
          'system_message': '系统消息',
          'user_message': '用户消息',
          'gift_message': '礼物消息',
          'join_message': '加入了房间',
          'leave_message': '离开了房间',
          
          // 网络状态
          'connecting': '连接中...',
          'connected': '已连接',
          'disconnected': '已断开',
          'connection_failed': '连接失败',
          'reconnecting': '重新连接中...',
          
          // 验证信息
          'field_required': '此字段为必填项',
          'invalid_format': '格式无效',
          'password_too_short': '密码太短',
          'username_too_short': '用户名太短',
        }
      };
}