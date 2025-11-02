-- 五星级高级混淆加密器

local file_path = gg.prompt({"选择要加密的Lua文件:"}, {gg.getFile()}, {"file"})
if not file_path then return end

local file = io.open(file_path[1], "rb")
if not file then
    gg.alert("无法打开文件")
    return
end

local content = file:read("*a")
file:close()

-- 编译为字节码
local chunk, err = load(content)
if not chunk then
    gg.alert("编译错误: " .. tostring(err))
    return
end

local bytecode = string.dump(chunk, true)

-- 表情符号集合
local emojis = {
    "🐶", "🐰", "🐻‍❄️", "🐮", "🐵", "🐒", "🐤", "🦆", "🦇", "🦄", "🐛", "🐜",
    "😀", "😆", "🤣", "😇", "😌", "😗", "😛", "🤨", "🥸", "😒", "😕", "😖", "😢", "😡",
    "🍏", "🍋", "🍓", "🍑", "🥝", "🫛", "🌶", "🫒", "🍠", "🍞", "🥚", "🧇", "🍖", "🍟"
}

-- 获取随机表情
local function get_random_emoji()
    return emojis[math.random(1, #emojis)]
end

-- 生成随机变量名
local function random_var_name()
    local names = {"Xc", "Ab", "Cd", "Ef", "Gh", "Ij", "Kl", "Mn", "Op", "Qr", "St", "Uv", "Wx", "Yz"}
    return names[math.random(1, #names)] .. "_" .. math.random(100, 999)
end

-- 创建高级混淆加载器
local function create_advanced_loader()
    -- 生成大量无用变量
    local junk_vars = ""
    for i = 1, 50 do
        local var_name = random_var_name()
        junk_vars = junk_vars .. "local " .. var_name .. " = \"" .. get_random_emoji() .. "\"\n"
    end
    
    -- 生成无用函数
    local junk_functions = ""
    for i = 1, 10 do
        local func_name = "FUNC_" .. math.random(1000, 9999)
        junk_functions = junk_functions .. "local function " .. func_name .. "(s)\n"
        for j = 1, 20 do
            junk_functions = junk_functions .. "local " .. random_var_name() .. " = s\n"
        end
        junk_functions = junk_functions .. "end\n"
    end
    
    -- 生成无用条件判断
    local junk_conditions = ""
    for i = 1, 20 do
        if math.random(1, 2) == 1 then
            junk_conditions = junk_conditions .. "if " .. math.random(0, 1) .. " == " .. math.random(0, 1) .. " then\n"
            junk_conditions = junk_conditions .. "  -- 无用代码\n"
            junk_conditions = junk_conditions .. "else\n"
            junk_conditions = junk_conditions .. "  -- 无用代码\n"
            junk_conditions = junk_conditions .. "end\n"
        else
            junk_conditions = junk_conditions .. "while false do\n"
            junk_conditions = junk_conditions .. "  print(\"" .. get_random_emoji() .. "\")\n"
            junk_conditions = junk_conditions .. "end\n"
        end
    end
    
    -- 创建基础加载器代码
    local base_code = [[
-- 加密难度: ⭐️⭐️⭐️☆☆
-- 作者: 无和空白
local And="加密难度: ⭐️⭐️⭐️☆☆"
local End="作者: 无和空白"
local a = ""..And..End
if 1==0 then
print (""..a)
print("傻子😂")
end
]] .. junk_vars .. [[

]] .. junk_functions .. [[

]] .. junk_conditions .. [[

local function SNC(s)
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
local VAHH=s
end
-- 生成随机混淆代码
EMOJI_PRINTS

-- 真实解密代码开始
local d={DATA}
local s=""
for i=1,#d do 
    if type(d[i]) == "number" then
        s=s..string.char(d[i]~0x55) 
    end
end

-- 最终无用代码
FINAL_JUNK

-- 执行解密后的代码
load(s)()
]]
    
    -- 加密字节码
    local encrypted_bytes = {}
    for i = 1, #bytecode do
        local byte = bytecode:byte(i)
        byte = byte ~ 0x55  -- XOR加密
        table.insert(encrypted_bytes, byte)
    end
    
    -- 将加密数据转换为字符串
    local data_str = ""
    for i, v in ipairs(encrypted_bytes) do
        data_str = data_str .. v .. ","
        -- 每30个字节换行
        if i % 30 == 0 then
            data_str = data_str .. "\n"
        end
    end
    data_str = data_str:sub(1, -2)  -- 移除最后的逗号
    
    -- 生成随机print语句
    local emoji_prints = ""
    for i = 1, math.random(5000, 20000) do
        if math.random(1, 3) == 1 then
            emoji_prints = emoji_prints .. "SNC(\"" .. get_random_emoji() .. "\")\n"
        else
            emoji_prints = emoji_prints .. "if false then SNC(\"" .. get_random_emoji() .. "\") end\n"
        end
    end
    
    -- 生成最终无用代码
    local final_junk = ""
    for i = 1, 30 do
        final_junk = final_junk .. "local junk_" .. i .. " = " .. math.random(1, 1000) .. "\n"
    end
    
    -- 替换模板中的占位符
    local final_code = base_code:gsub("DATA", data_str)
    final_code = final_code:gsub("EMOJI_PRINTS", emoji_prints)
    final_code = final_code:gsub("FINAL_JUNK", final_junk)
    
    return final_code
end

-- 设置随机种子
math.randomseed(os.time())

-- 执行加密过程
local loader_code = create_advanced_loader()

-- 编译为字节码
local loader_chunk, compile_err = load(loader_code)
if not loader_chunk then
    gg.alert("编译错误: " .. tostring(compile_err))
    return
end

local final_bytecode = string.dump(loader_chunk, true)

-- 写入最终加密文件
local output_path = file_path[1] .. "_加密.lua"
local output_file = io.open(output_path, "wb")
if output_file then
    output_file:write(final_bytecode)
    output_file:close()
    
    -- 验证文件是否包含可读文字和表情
    local verify_file = io.open(output_path, "rb")
    local verify_content = verify_file:read("*a")
    verify_file:close()
    
    if verify_content:find("加密难度") then
        gg.alert("高级混淆加密完成！\n输出文件: " .. output_path .. "\n\n文件已成功嵌入多重混淆保护")
    else
        gg.alert("警告：版权信息可能未正确嵌入")
    end
    
    -- 测试加载
    local test_chunk = load(final_bytecode)
    if test_chunk then
        gg.alert("加密文件测试加载成功！")
    else
        gg.alert("警告：加密文件可能无法加载")
    end
else
    gg.alert("无法创建输出文件")
end