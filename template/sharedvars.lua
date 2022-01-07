xero()
yes = (IsNITG() and 1) or true
no = (IsNITG() and 0) or false

function hide(a)
    a:visible(no)
end
function show(a)
    a:visible(yes)
end

Blend = {
    Normal = (IsNITG() and 'normal') or 'BlendMode_Normal',
    Add = (IsNITG() and 'add') or 'BlendMode_Add',
    WeightedAdd = (IsNITG() and 'weightedadd') or 'BlendMode_WeightedAdd',
    Subtract = (IsNITG() and 'subtract') or 'BlendMode_Subtract',
    Multiply = (IsNITG() and 'multiply') or 'BlendMode_Multiply',
    WeightedMultiply = (IsNITG() and 'weightedmultiply') or 'BlendMode_WeightedMultiply',
    InvertDest = (IsNITG() and 'invertdest') or 'BlendMode_InvertDest',
    NoEffect = (IsNITG() and 'noeffect') or 'BlendMode_NoEffect',
    CopySrc = (IsNITG() and 'copysrc') or 'BlendMode_CopySrc',
}
ZTestMode = {
    Pass = (IsNITG() and 'writeonpass') or 'ZTestMode_WriteOnPass',
    Fail = (IsNITG() and 'writeonfail') or 'ZTestMode_WriteOnFail',
}
