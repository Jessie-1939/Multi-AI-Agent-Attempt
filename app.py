import os
from flask import Flask, render_template, request, jsonify, Response
from flask_cors import CORS
from dotenv import load_dotenv
import json
import time
from datetime import datetime
import httpx  # 使用 httpx 替代 openai SDK

# 加载环境变量
load_dotenv()

app = Flask(__name__)
CORS(app)

def deepseek_chat_completion(system_prompt, user_content, model="deepseek-chat", temperature=0.7):
    """
    使用 httpx 直接请求 DeepSeek Chat Completions 接口，完全屏蔽系统代理。
    """
    api_key = os.getenv('DEEPSEEK_API_KEY')
    if not api_key or api_key == 'your_api_key_here':
        return "API调用错误: 未在 .env 文件中配置 DEEPSEEK_API_KEY"

    base_url = os.getenv('DEEPSEEK_BASE_URL', 'https://api.deepseek.com/v1').rstrip('/')
    url = f"{base_url}/chat/completions"

    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": system_prompt or ""},
            {"role": "user", "content": user_content or ""}
        ],
        "temperature": float(temperature),
        "stream": False
    }
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }

    # 彻底禁用代理与环境注入（例如 127.0.0.1:7890）
    try:
        # 创建一个不使用代理且不信任环境代理的 httpx 客户端
        with httpx.Client(timeout=60.0, proxies=None, trust_env=False) as client:
            resp = client.post(url, headers=headers, json=payload)
        
        resp.raise_for_status()  # 如果状态码不是 2xx，则引发异常
        
        data = resp.json()
        return data["choices"][0]["message"]["content"]
    except httpx.HTTPStatusError as e:
        # 返回更友好的HTTP错误信息
        error_body = e.response.text[:500]  # 限制错误信息长度
        return f"API调用错误: HTTP {e.response.status_code} - {error_body}"
    except httpx.RequestError as e:
        # 处理连接错误、超时等网络问题
        return f"API调用错误: 网络请求失败 - {type(e).__name__}"
    except (KeyError, IndexError) as e:
        # 处理API返回数据结构不符合预期的问题
        return f"API调用错误: 解析响应失败 - {e}"
    except Exception as e:
        # 其他未知错误
        return f"API调用错误: 发生未知错误 - {e}"

class MultiAgentSystem:
    """多AI代理协调系统"""
    
    def __init__(self):
        self.process_log = []
    
    def log_step(self, step_name, content, agent_type):
        """记录处理步骤"""
        log_entry = {
            'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
            'step': step_name,
            'agent': agent_type,
            'content': content
        }
        self.process_log.append(log_entry)
        return log_entry
    
    def call_ai(self, system_prompt, user_content, model="deepseek-chat", temperature=0.7):
        """调用DeepSeek API（改为httpx直连）"""
        return deepseek_chat_completion(system_prompt, user_content, model=model, temperature=temperature)
    
    def weak_ai_decompose(self, user_input):
        """弱AI - 拆解用户输入"""
        system_prompt = """你是一个内容拆解专家。你的任务是将用户的输入拆解成清晰的要点。
请按照以下格式输出：
1. 核心问题：[提取主要问题]
2. 关键要素：[列出关键信息点]
3. 预期目标：[用户想要达到的目标]

保持简洁，每个部分不超过3个要点。"""
        
        result = self.call_ai(system_prompt, user_input, temperature=0.5)
        self.log_step("内容拆解", result, "弱AI-拆解器")
        return result
    
    def prompt_ai_optimize(self, decomposed_content):
        """提示词AI - 生成优化的提示词"""
        system_prompt = """你是一个提示词工程专家。根据拆解的内容，生成一个优化的提示词，用于指导强AI进行综合回答。
你的提示词应该：
1. 明确指出需要回答的核心问题
2. 列出需要涵盖的要点
3. 说明回答的结构和风格要求

直接输出提示词，不要有多余的说明。"""
        
        result = self.call_ai(system_prompt, f"拆解内容：\n{decomposed_content}", temperature=0.6)
        self.log_step("提示词生成", result, "提示词AI")
        return result
    
    def strong_ai_synthesize(self, optimized_prompt, decomposed_content, original_input):
        """强AI - 综合分析和回答"""
        system_prompt = f"""你是一个高级AI助手，负责提供全面、深入的回答。

【指导提示词】
{optimized_prompt}

【拆解的内容要点】
{decomposed_content}

请基于以上信息，针对用户的原始问题提供详细、准确、有价值的回答。"""
        
        result = self.call_ai(system_prompt, f"用户原始输入：{original_input}", model="deepseek-chat", temperature=0.7)
        self.log_step("综合分析", result, "强AI-分析器")
        return result
    
    def weak_ai_format(self, synthesized_content):
        """弱AI - 格式化输出"""
        system_prompt = """你是一个输出格式化助手。将内容整理成用户友好的格式。
要求：
1. 使用清晰的标题和分段
2. 重点内容使用【】标注
3. 保持内容完整，不要删减
4. 适当使用换行和空格提升可读性

直接输出格式化后的内容。"""
        
        result = self.call_ai(system_prompt, synthesized_content, temperature=0.3)
        self.log_step("格式化输出", result, "弱AI-格式化器")
        return result
    
    def process(self, user_input):
        """完整处理流程"""
        self.process_log = []
        self.log_step("接收输入", user_input, "系统")
        
        # 步骤1: 弱AI拆解
        decomposed = self.weak_ai_decompose(user_input)
        if "API调用错误" in decomposed:
            return {'final_output': decomposed, 'process_log': self.process_log, 'intermediate_results': {}}

        # 步骤2: 提示词AI优化
        optimized_prompt = self.prompt_ai_optimize(decomposed)
        if "API调用错误" in optimized_prompt:
            return {'final_output': optimized_prompt, 'process_log': self.process_log, 'intermediate_results': {'decomposed': decomposed}}

        # 步骤3: 强AI综合
        synthesized = self.strong_ai_synthesize(optimized_prompt, decomposed, user_input)
        if "API调用错误" in synthesized:
            return {'final_output': synthesized, 'process_log': self.process_log, 'intermediate_results': {'decomposed': decomposed, 'optimized_prompt': optimized_prompt}}

        # 步骤4: 弱AI格式化
        final_output = self.weak_ai_format(synthesized)
        
        self.log_step("完成处理", "流程结束", "系统")
        
        return {
            'final_output': final_output,
            'process_log': self.process_log,
            'intermediate_results': {
                'decomposed': decomposed,
                'optimized_prompt': optimized_prompt,
                'synthesized': synthesized
            }
        }

# 创建全局代理系统实例
agent_system = MultiAgentSystem()

@app.route('/')
def index():
    """主页"""
    return render_template('index.html')

@app.route('/api/process', methods=['POST'])
def process_request():
    """处理用户请求"""
    try:
        data = request.get_json()
        user_input = data.get('input', '')
        
        if not user_input:
            return jsonify({'error': '输入不能为空'}), 400
        
        # 处理请求
        result = agent_system.process(user_input)
        
        return jsonify({
            'success': True,
            'result': result
        })
    
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/api/health', methods=['GET'])
def health_check():
    """健康检查"""
    api_key = os.getenv('DEEPSEEK_API_KEY')
    return jsonify({
        'status': 'ok',
        'api_configured': bool(api_key and api_key != 'your_api_key_here')
    })

if __name__ == '__main__':
    print("=" * 60)
    print("🚀 多AI代理系统启动中...")
    print("=" * 60)
    print(f"📍 访问地址: http://localhost:5000")
    print(f"⚙️  API配置: {'已配置' if os.getenv('DEEPSEEK_API_KEY') and os.getenv('DEEPSEEK_API_KEY') != 'your_api_key_here' else '未配置（请设置.env文件）'}")
    print("=" * 60)
    app.run(debug=True, host='0.0.0.0', port=5000)
