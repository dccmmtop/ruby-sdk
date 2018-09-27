#!/usr/bin/env ruby

require 'qiniu'

# 构建鉴权对象
Qiniu.establish_connection! access_key: 'Access_Key',
                            secret_key: 'Secret_Key'

bucket = 'Bucket_Name'

key = 'my-ruby-logo.png'

put_policy = Qiniu::Auth::PutPolicy.new(
    bucket, # 存储空间
    key,    # 最终资源名，可省略，即缺省为“创建”语义，设置为 nil 为普通上传
    3600    # token 过期时间，默认为 3600s
)

# 构建回调策略，这里上传文件到七牛后， 七牛将文件名和文件大小回调给业务服务器
callback_url = 'http://your.domain.com/callback'
callback_body = 'filename=$(fname)&filesize=$(fsize)'

put_policy.callback_url = callback_url
put_policy.callback_body = callback_body

#生成上传 Token
uptoken = Qiniu::Auth.generate_uptoken(put_policy)

#要上传文件的本地路径
filePath = './ruby-logo.png'

# 调用 upload_file 方法上传
info = Qiniu.upload_file uptoken: uptoken, file: filePath, bucket: bucket, key: key

# 打印文件信息
puts info
