-- 分割字符串函数
function split(str, delimiter)  
    -- 结果表  
    local result = {}  
    local current = ""  
    for i = 1, #str do  
        if str:sub(i, i) == delimiter then  
            if #current > 0 then  
                table.insert(result, current)  
            end  
            current = ""  
        else  
            current = current .. str:sub(i, i)  
        end  
    end   
    if #current > 0 then  
        table.insert(result, current)  
    end  
    return result  
end

-- 根据目的地址和当前地址，获得单位向量
function getAngle(curPos, desPos)
    -- 获取计算向量
    local angle = {
        x = desPos.x - curPos.x,
        y = desPos.y - curPos.y,
        z = desPos.z - curPos.z
    }
    -- 单位化
    local temp = (angle.x^2 + angle.y^2 + angle.z^2)^0.5
    angle.x = angle.x / temp
    angle.y = angle.y / temp
    angle.z = angle.z / temp
    return angle
end

-- 获取距离的平方
function getDistance(curPos, desPos)
    -- 获取计算向量
    local angle = {
        x = desPos.x - curPos.x,
        y = desPos.y - curPos.y,
        z = desPos.z - curPos.z
    }
    return (angle.x^2 + angle.y^2 + angle.z^2)^0.5
end

-- 获得当前质量质量
local mass = ship.getMass()
print("mass =",mass)
-- 获取当前船坐标
local curPos = ship.getWorldspacePosition()
print("currentPos =", curPos.x, curPos.y, curPos.z)
-- 输入目的地
local desPos
print("input destination(xyz) example:123 [89] 345")
local input = io.read()
local args = split(input, ' ')
if (#args == 3) then    -- 分别处理输入高度和不输入高度的情况
    desPos = { x=tonumber(args[1]), y=tonumber(args[2]), z=tonumber(args[3])}
else
    desPos = { x=tonumber(args[1]), y=curPos.y, z=tonumber(args[2])}
end
print("destinationPos =", desPos.x, desPos.y, desPos.z)

-- 输入速度 开始加力
print("input speed(60)")
local speed = tonumber(io.read())
speed = speed * mass

-- 检测是否到达目的地，并实时调整方向
while(true)
do
    -- 计算角度
    local curPos = ship.getWorldspacePosition()
    local angle = getAngle(curPos, desPos)
    ship.applyInvariantForce(speed*angle.x, speed*angle.y, speed*angle.z)
    -- 计算距离
    local dis = getDistance(curPos, desPos)
    print("dis =", dis)
    if(dis < 50)then
        break
    end
    sleep(0.1)  -- 如果过快，会导致飞船瞬间加速，飞出游戏 如果过慢，则会显得飞行不流畅
end

