# ⚠️ 多AI代理协作系统 - 未完成项目

## 🚨 项目状态：未成功完成

**本项目在开发过程中遇到无法解决的技术问题，未能实现预期功能。**

### ❌ 主要问题

1. **DeepSeek API代理冲突**
   - 在使用代理环境时，OpenAI SDK与httpx库存在不兼容问题
   - 错误信息：`Client.__init__() got an unexpected keyword argument 'proxies'`

2. **环境依赖复杂**
   - 需要处理系统代理环境变量
   - Python包版本兼容性问题
   - 虚拟环境配置繁琐

3. **开发效率低**
   - 从零搭建Flask后端
   - 手写前端HTML/CSS/JavaScript
   - 调试API调用问题耗时长

## ✅ 推荐的替代方案

如果您想实现类似的多AI代理协作功能，以下是**更成熟、更可靠**的替代方案：

### 🥇 方案1：n8n（强烈推荐）⭐⭐⭐⭐⭐
**最适合非程序员和快速原型开发**

- **官网**: https://n8n.io/
- **特点**:
  - 可视化工作流编辑器，无需编程
  - 内置DeepSeek/OpenAI集成
  - 自动处理API调用和错误重试
  - 支持条件分支、循环、并行处理
  - 开源免费，可本地部署
  - 活跃社区，大量模板

**使用n8n实现多AI协作：**
```
1. 安装 n8n: npm install -g n8n
2. 启动: n8n start
3. 在浏览器打开可视化编辑器
4. 拖拽节点创建工作流：
   输入 → AI节点(拆解) → AI节点(优化) → AI节点(分析) → AI节点(格式化) → 输出
5. 配置API密钥，点击执行
```

**优势**: 零代码、稳定、易维护、功能强大

---

### 🥈 方案2：Dify.ai ⭐⭐⭐⭐⭐
**最适合构建AI应用和对话系统**

- **官网**: https://dify.ai/
- **GitHub**: https://github.com/langgenius/dify
- **特点**:
  - 专为LLM应用设计的开发平台
  - 内置Prompt编排、Agent编排
  - 支持多种AI模型（OpenAI、DeepSeek、Claude等）
  - 提供美观的对话界面
  - RAG（检索增强生成）支持
  - 一键部署，Docker支持

**适用场景**: AI聊天机器人、知识库问答、工作流自动化

---

### 🥉 方案3：LangChain + LangGraph ⭐⭐⭐⭐
**最适合Python开发者**

- **官网**: https://www.langchain.com/
- **GitHub**: https://github.com/langchain-ai/langchain
- **特点**:
  - 成熟的Python AI开发框架
  - 丰富的工具链和集成
  - LangGraph提供状态图编排
  - 社区庞大，文档完善
  - 灵活可扩展

**示例代码**:
```python
from langchain.chat_models import ChatOpenAI
from langgraph.graph import StateGraph

# 定义工作流
workflow = StateGraph()
workflow.add_node("decompose", decompose_agent)
workflow.add_node("optimize", optimize_agent)
workflow.add_node("synthesize", synthesize_agent)
workflow.add_node("format", format_agent)
workflow.add_edge("decompose", "optimize")
# ... 自动处理错误和重试
```

---

### 🏅 方案4：Flowise ⭐⭐⭐⭐
**可视化LangChain构建器**

- **官网**: https://flowiseai.com/
- **GitHub**: https://github.com/FlowiseAI/Flowise
- **特点**:
  - 拖拽式构建LangChain应用
  - 低代码/无代码
  - 支持多种LLM和工具
  - 美观的UI界面
  - 快速部署

**适用场景**: 快速原型开发、非技术团队

---

### 🏅 方案5：AutoGPT / MetaGPT ⭐⭐⭐
**自主AI代理框架**

- **AutoGPT**: https://github.com/Significant-Gravitas/AutoGPT
- **MetaGPT**: https://github.com/geekan/MetaGPT
- **特点**:
  - 自主任务规划和执行
  - 多角色协作
  - 长期记忆和反思
  - 工具调用能力

**适用场景**: 复杂任务自动化、研究实验

---

### 🏅 方案6：CrewAI ⭐⭐⭐⭐
**多Agent协作框架**

- **官网**: https://www.crewai.com/
- **GitHub**: https://github.com/joaomdmoura/crewAI
- **特点**:
  - 专注于多Agent协作
  - 角色分工明确
  - 任务自动分配
  - Python API简洁

**示例**:
```python
from crewai import Agent, Task, Crew

decomposer = Agent(role="内容拆解专家", ...)
optimizer = Agent(role="提示词工程师", ...)
analyst = Agent(role="分析师", ...)
formatter = Agent(role="格式化助手", ...)

crew = Crew(agents=[decomposer, optimizer, analyst, formatter])
result = crew.kickoff(inputs={"query": "设计一个电商平台"})
```

---

## 📊 方案对比

| 方案 | 难度 | 稳定性 | 开发速度 | 适合人群 |
|------|------|--------|----------|----------|
| **n8n** | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 所有人 |
| **Dify.ai** | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 产品经理、开发者 |
| **LangChain** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | Python开发者 |
| **Flowise** | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 非技术人员 |
| **AutoGPT** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | 研究人员 |
| **CrewAI** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Python开发者 |
| **本项目** | ⭐⭐⭐⭐⭐ | ⭐ | ⭐ | ❌ 不推荐 |

---

## 💡 为什么不推荐继续使用本项目

1. **技术债务高**: 需要解决OpenAI SDK、httpx、代理环境等多个兼容性问题
2. **维护成本大**: 手写代码需要持续维护和调试
3. **功能有限**: 缺少成熟框架的高级特性（重试、容错、监控等）
4. **学习成本**: 需要理解Flask、前端开发、API调用等多项技术
5. **没有社区支持**: 遇到问题无法快速获得帮助

---

## 🎯 建议行动方案

### 如果您是非程序员：
👉 **使用 n8n 或 Dify.ai**
- 10分钟内即可搭建可用的多AI工作流
- 无需编程知识
- 稳定可靠

### 如果您是Python开发者：
👉 **使用 LangChain + LangGraph 或 CrewAI**
- 成熟的框架，代码示例丰富
- 社区活跃，问题容易解决
- 可扩展性强

### 如果您想快速验证想法：
👉 **使用 Flowise 或 n8n**
- 可视化编辑
- 快速迭代
- 无需处理底层技术细节

---

## 📚 学习资源

### n8n
- 官方文档: https://docs.n8n.io/
- 中文教程: B站搜索"n8n教程"
- 模板库: https://n8n.io/workflows/

### Dify.ai
- 官方文档: https://docs.dify.ai/
- GitHub中文文档: https://github.com/langgenius/dify/tree/main/README_CN.md

### LangChain
- 官方文档: https://python.langchain.com/
- 中文社区: https://www.langchain.com.cn/

---

## ⚠️ 本项目代码说明

本仓库保留代码仅供参考学习，**不建议用于生产环境**。

如果您仍想尝试运行本项目（仅供学习）：

## 🚀 快速开始

### 1. 安装依赖

运行自动化安装脚本：

**Windows PowerShell:**
```powershell
.\setup.ps1
```

**Windows CMD:**
```cmd
setup.bat
```

**手动安装:**
```bash
# 创建虚拟环境
python -m venv venv

# 激活虚拟环境 (Windows)
venv\Scripts\activate

# 安装依赖
pip install -r requirements.txt
```

### 2. 配置API密钥

1. 复制 `.env.example` 为 `.env`
2. 编辑 `.env` 文件，填入你的DeepSeek API密钥：

```env
DEEPSEEK_API_KEY=你的API密钥
```

获取API密钥：https://platform.deepseek.com/

### 3. 运行应用

**使用启动脚本（推荐）:**

Windows PowerShell:
```powershell
.\run.ps1
```

Windows CMD:
```cmd
run.bat
```

**手动启动:**
```bash
# 激活虚拟环境
venv\Scripts\activate

# 运行应用
python app.py
```

### 4. 访问应用

打开浏览器访问: http://localhost:5000

## 📁 项目结构

```
Muli_AiAgent_Title_Css_result/
├── app.py                 # Flask后端主程序
├── requirements.txt       # Python依赖
├── .env                   # 环境变量配置（需创建）
├── .env.example          # 环境变量示例
├── setup.ps1             # Windows PowerShell 安装脚本
├── setup.bat             # Windows CMD 安装脚本
├── run.ps1               # Windows PowerShell 启动脚本
├── run.bat               # Windows CMD 启动脚本
├── README.md             # 本文档
├── templates/
│   └── index.html        # 前端HTML
└── static/
    ├── css/
    │   └── style.css     # 样式文件
    └── js/
        └── main.js       # 前端JavaScript
```

## 🎯 使用方法

1. **输入问题**: 在左侧输入框输入你的问题或需求
2. **开始处理**: 点击"开始处理"按钮
3. **查看结果**: 
   - 右侧显示最终格式化的结果
   - 可展开"中间过程"查看每个AI代理的输出
   - 可展开"处理日志"查看详细的处理流程
4. **复制内容**: 点击复制按钮可以复制结果或中间过程

## 🔧 技术栈

### 后端
- **Flask**: Web框架
- **OpenAI SDK**: API调用
- **python-dotenv**: 环境变量管理

### 前端
- **原生JavaScript**: 无框架依赖
- **现代CSS**: 响应式设计
- **Fetch API**: HTTP请求

### AI服务
- **DeepSeek API**: 提供AI能力
- **兼容OpenAI格式**: 易于集成

## 📊 处理流程

```
用户输入
    ↓
【步骤1】弱AI拆解器
    ├─ 提取核心问题
    ├─ 识别关键要素
    └─ 明确预期目标
    ↓
【步骤2】提示词AI
    ├─ 分析拆解内容
    ├─ 优化提示词
    └─ 生成指导prompt
    ↓
【步骤3】强AI分析器
    ├─ 综合理解问题
    ├─ 深度分析
    └─ 生成详细回答
    ↓
【步骤4】弱AI格式化器
    ├─ 优化排版
    ├─ 添加标注
    └─ 提升可读性
    ↓
最终输出
```

## 🛠️ 高级配置

### 修改AI模型

编辑 `app.py` 中的模型参数：

```python
# 使用思考模式
model="deepseek-reasoner"

# 调整温度参数
temperature=0.7  # 0.0-1.0，越高越有创造性
```

### 自定义端口

编辑 `app.py` 最后一行：

```python
app.run(debug=True, host='0.0.0.0', port=5000)  # 修改端口号
```

### 修改系统提示词

在 `app.py` 的 `MultiAgentSystem` 类中修改各个AI代理的 `system_prompt`。

## 📝 依赖管理

### 查看已安装的包

```bash
# 激活虚拟环境
venv\Scripts\activate

# 查看包列表
pip list

# 导出当前环境
pip freeze > requirements.txt
```

### 更新依赖

```bash
pip install --upgrade flask openai python-dotenv
```

## 🐛 故障排除

### API未配置

**问题**: 状态显示"API未配置"

**解决**: 
1. 确认 `.env` 文件存在
2. 检查 `DEEPSEEK_API_KEY` 是否正确设置
3. 重启应用

### 导入错误

**问题**: `ModuleNotFoundError: No module named 'flask'`

**解决**:
```bash
# 确保虚拟环境已激活
venv\Scripts\activate

# 重新安装依赖
pip install -r requirements.txt
```

### 端口被占用

**问题**: `Address already in use`

**解决**:
1. 关闭占用5000端口的其他程序
2. 或修改 `app.py` 使用其他端口

### CORS错误

**问题**: 浏览器控制台显示CORS错误

**解决**: 已配置 `flask-cors`，如仍有问题，检查浏览器是否阻止了请求

## 🎨 自定义主题

编辑 `static/css/style.css` 中的CSS变量：

```css
:root {
    --primary-color: #6366f1;      /* 主色调 */
    --bg-color: #0f172a;           /* 背景色 */
    --card-bg: #1e293b;            /* 卡片背景 */
    --text-primary: #f1f5f9;       /* 主文本颜色 */
    /* ... 更多配置 */
}
```

## ⚠️ 免责声明

本项目为未完成的实验性项目，存在已知的技术问题。作者不对使用本代码产生的任何问题负责。

**强烈建议使用上述推荐的成熟替代方案。**

---

## � 许可证

MIT License

## 🔗 推荐链接

- [n8n 官网](https://n8n.io/) - 推荐优先使用
- [Dify.ai 官网](https://dify.ai/) - AI应用开发平台
- [LangChain 文档](https://python.langchain.com/) - Python AI框架
- [Flowise 官网](https://flowiseai.com/) - 可视化AI应用构建器
- [CrewAI GitHub](https://github.com/joaomdmoura/crewAI) - 多Agent协作框架

---

⚠️ **本项目未能成功完成，请使用推荐的替代方案！**
