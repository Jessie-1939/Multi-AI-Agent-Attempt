// 全局变量
let isProcessing = false;

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

// 初始化应用
function initializeApp() {
    checkApiStatus();
    bindEventListeners();
}

// 检查API状态
async function checkApiStatus() {
    try {
        const response = await fetch('/api/health');
        const data = await response.json();
        
        const statusIndicator = document.getElementById('apiStatus');
        const statusDot = statusIndicator.querySelector('.status-dot');
        const statusText = statusIndicator.querySelector('.status-text');
        
        if (data.status === 'ok' && data.api_configured) {
            statusDot.style.background = '#10b981';
            statusText.textContent = 'API已配置 ✓';
        } else {
            statusDot.style.background = '#f59e0b';
            statusText.textContent = 'API未配置';
        }
    } catch (error) {
        console.error('API状态检查失败:', error);
        const statusIndicator = document.getElementById('apiStatus');
        const statusDot = statusIndicator.querySelector('.status-dot');
        const statusText = statusIndicator.querySelector('.status-text');
        statusDot.style.background = '#ef4444';
        statusText.textContent = '服务器未连接';
    }
}

// 绑定事件监听器
function bindEventListeners() {
    // 提交按钮
    document.getElementById('submitBtn').addEventListener('click', handleSubmit);
    
    // 清空按钮
    document.getElementById('clearBtn').addEventListener('click', handleClear);
    
    // 复制结果按钮
    document.getElementById('copyResultBtn').addEventListener('click', () => {
        copyToClipboard('finalOutput');
    });
    
    // 中间过程折叠
    document.getElementById('intermediateHeader').addEventListener('click', function() {
        toggleCollapse('intermediateContent', this.querySelector('.collapse-icon'));
    });
    
    // 日志折叠
    document.getElementById('logHeader').addEventListener('click', function() {
        toggleCollapse('processLog', this.querySelector('.collapse-icon'));
    });
    
    // 中间过程复制按钮
    document.querySelectorAll('.btn-copy-small').forEach(btn => {
        btn.addEventListener('click', function() {
            const target = this.getAttribute('data-target');
            copyToClipboard(target);
        });
    });
    
    // Enter键提交（Ctrl+Enter）
    document.getElementById('userInput').addEventListener('keydown', function(e) {
        if (e.ctrlKey && e.key === 'Enter') {
            handleSubmit();
        }
    });
}

// 处理提交
async function handleSubmit() {
    if (isProcessing) {
        showNotification('处理中，请稍候...', 'warning');
        return;
    }
    
    const userInput = document.getElementById('userInput').value.trim();
    
    if (!userInput) {
        showNotification('请输入您的问题', 'warning');
        return;
    }
    
    isProcessing = true;
    showLoading(true);
    resetFlowSteps();
    clearOutputs();
    
    const submitBtn = document.getElementById('submitBtn');
    submitBtn.disabled = true;
    submitBtn.querySelector('.btn-text').textContent = '处理中...';
    
    try {
        const response = await fetch('/api/process', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ input: userInput })
        });
        
        if (!response.ok) {
            throw new Error('请求失败');
        }
        
        const data = await response.json();
        
        if (data.success) {
            displayResults(data.result);
            showNotification('处理完成！', 'success');
        } else {
            throw new Error(data.error || '处理失败');
        }
    } catch (error) {
        console.error('处理错误:', error);
        showNotification('处理失败: ' + error.message, 'error');
        document.getElementById('finalOutput').innerHTML = `
            <div style="color: #ef4444; padding: 20px; text-align: center;">
                <p style="font-size: 1.2em; margin-bottom: 10px;">❌ 处理失败</p>
                <p>${error.message}</p>
            </div>
        `;
    } finally {
        isProcessing = false;
        showLoading(false);
        submitBtn.disabled = false;
        submitBtn.querySelector('.btn-text').textContent = '开始处理';
    }
}

// 显示结果
function displayResults(result) {
    // 显示最终输出
    const finalOutput = document.getElementById('finalOutput');
    finalOutput.innerHTML = formatOutput(result.final_output);
    
    // 显示中间结果
    if (result.intermediate_results) {
        document.getElementById('decomposed').textContent = result.intermediate_results.decomposed;
        document.getElementById('optimizedPrompt').textContent = result.intermediate_results.optimized_prompt;
        document.getElementById('synthesized').textContent = result.intermediate_results.synthesized;
    }
    
    // 显示处理日志
    if (result.process_log) {
        displayProcessLog(result.process_log);
    }
    
    // 更新流程步骤
    updateFlowSteps(result.process_log);
}

// 格式化输出内容
function formatOutput(text) {
    // 简单的Markdown风格格式化
    let formatted = text
        .replace(/【([^】]+)】/g, '<strong style="color: #6366f1;">$1</strong>')
        .replace(/\n\n/g, '</p><p>')
        .replace(/\n/g, '<br>');
    
    return `<p>${formatted}</p>`;
}

// 显示处理日志
function displayProcessLog(logs) {
    const logContent = document.getElementById('processLog');
    logContent.innerHTML = '';
    
    logs.forEach(log => {
        const logEntry = document.createElement('div');
        logEntry.className = 'log-entry';
        logEntry.innerHTML = `
            <span class="log-timestamp">${log.timestamp}</span>
            <span class="log-agent">[${log.agent}]</span>
            <span class="log-step">${log.step}</span>
            <div class="log-content-text">${truncateText(log.content, 150)}</div>
        `;
        logContent.appendChild(logEntry);
    });
}

// 更新流程步骤
function updateFlowSteps(logs) {
    const stepMap = {
        '内容拆解': 1,
        '提示词生成': 2,
        '综合分析': 3,
        '格式化输出': 4
    };
    
    logs.forEach(log => {
        const stepNum = stepMap[log.step];
        if (stepNum) {
            const stepElement = document.querySelector(`.flow-step[data-step="${stepNum}"]`);
            if (stepElement) {
                stepElement.classList.add('completed');
                stepElement.querySelector('.step-status').textContent = '已完成';
            }
        }
    });
}

// 重置流程步骤
function resetFlowSteps() {
    document.querySelectorAll('.flow-step').forEach(step => {
        step.classList.remove('active', 'completed');
        step.querySelector('.step-status').textContent = '等待中';
    });
}

// 清空输出
function clearOutputs() {
    document.getElementById('finalOutput').innerHTML = '<div class="placeholder">处理中...</div>';
    document.getElementById('decomposed').textContent = '处理中...';
    document.getElementById('optimizedPrompt').textContent = '处理中...';
    document.getElementById('synthesized').textContent = '处理中...';
    document.getElementById('processLog').innerHTML = '<div class="placeholder">处理中...</div>';
}

// 处理清空
function handleClear() {
    document.getElementById('userInput').value = '';
    document.getElementById('finalOutput').innerHTML = '<div class="placeholder">处理完成后，结果将在此显示...</div>';
    document.getElementById('decomposed').textContent = '等待处理...';
    document.getElementById('optimizedPrompt').textContent = '等待处理...';
    document.getElementById('synthesized').textContent = '等待处理...';
    document.getElementById('processLog').innerHTML = '<div class="placeholder">处理日志将在此显示...</div>';
    resetFlowSteps();
}

// 折叠/展开
function toggleCollapse(contentId, iconElement) {
    const content = document.getElementById(contentId);
    const isHidden = content.style.display === 'none';
    
    content.style.display = isHidden ? 'block' : 'none';
    iconElement.classList.toggle('collapsed', !isHidden);
}

// 复制到剪贴板
async function copyToClipboard(elementId) {
    const element = document.getElementById(elementId);
    const text = element.textContent || element.innerText;
    
    try {
        await navigator.clipboard.writeText(text);
        showNotification('已复制到剪贴板', 'success');
    } catch (error) {
        console.error('复制失败:', error);
        showNotification('复制失败', 'error');
    }
}

// 显示/隐藏加载动画
function showLoading(show) {
    const overlay = document.getElementById('loadingOverlay');
    overlay.style.display = show ? 'flex' : 'none';
}

// 显示通知
function showNotification(message, type = 'info') {
    const colors = {
        success: '#10b981',
        warning: '#f59e0b',
        error: '#ef4444',
        info: '#6366f1'
    };
    
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${colors[type]};
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
        z-index: 2000;
        animation: slideIn 0.3s ease;
    `;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// 截断文本
function truncateText(text, maxLength) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
}

// 添加CSS动画
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);
