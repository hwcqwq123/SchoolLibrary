/**
 * 前端公共脚本。
 * 当前主要用于统一删除/归还确认提示，后续可扩展表单校验、异步查询等功能。
 */
function confirmDelete(message) {
    return window.confirm(message || '确定执行该操作吗？');
}
