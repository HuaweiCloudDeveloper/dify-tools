# DeepSeek_Dify Community Edition Tool Guide
## Product Link
[DeepSeek_Dify Community Edition](https://marketplace.huaweicloud.com/contents/c2624f6f-2e5e-4e0e-813a-832bd101101e#productid=OFFI1137707809154215936)

## Product Description
DeepSeek-R1 is a high-performance AI inference model focusing on mathematical, coding, and natural language reasoning tasks. By deploying the distilled lightweight version of DeepSeek-R1 via Ollama on cloud servers, you can quickly build your personal AI assistant. Application scenarios include:
- Natural Language Processing (NLP): Capable of understanding and generating natural language text, suitable for dialogue, translation, summarization, etc.
- Text Generation: Can produce coherent and logically clear text, ideal for content creation, story writing, etc.
- Q&A Systems: Able to answer user queries, suitable for customer service, knowledge base searches, etc.
- Sentiment Analysis: Can analyze emotional tendencies in text, useful for market research, public opinion monitoring, etc.
- Text Classification: Capable of categorizing text, applicable for spam filtering, news classification, etc.
- Information Extraction: Able to extract key information from text, suitable for data mining, knowledge graph construction, etc.<br>

Dify is an open-source large language model (LLM) application development platform. It combines Backend as a Service (BaaS) and LLMOps concepts, enabling developers to quickly build production-ready generative AI applications. Even non-technical users can participate in defining AI applications and managing data operations.

Dify includes essential technical stacks for building LLM applications:
- Support for hundreds of models
- Intuitive Prompt orchestration interface
- High-quality RAG engine
- Robust Agent framework
- Flexible workflow orchestration
- User-friendly UI and API

This saves developers time from reinventing the wheel, allowing focus on innovation and business needs.<br>

This product is provided as a pre-installed image on Kunpeng Cloud with Ubuntu 24.04 and HCE 2.0 systems.

## Product Purchase
Search for "DeepSeek_Dify Community Edition" in the Cloud Marketplace.<br>
For region and specifications, use recommended configurations. Choose billing method (Pay-as-you-go for short-term use, Monthly/Annual for long-term use), then click "Buy Now" after confirming configurations.

![alt text](./images/image.png)

### Direct Deployment Using RFS Template
![img.png](images/img1.png)
After filling required fields, click Next
![img.png](images/img2.png)
![img.png](images/img3.png)
After creating direct plan, click Confirm
![img.png](images/img4.png)
![img.png](images/img5.png)
Click Deploy to execute plan
![img.png](images/img6.png)
"Apply required resource success" indicates completion
![img.png](images/img7.png)

### ECS Console Configuration
#### Preparations

Before ECS console configuration, configure **security group rules**:

> **Security Group Rules:**
> - Allow inbound traffic on port 80 (must include your client IP)
> - Allow inbound traffic on port `22` for CloudShell connections
> - Enable all outbound traffic

#### Create ECS

After preparations, go to [ECS Purchase Page](https://support.huaweicloud.com/qs-ecs/ecs_01_0103.html):

Select CPU architecture
![img.png](images/img8.png)
Select server specifications
![img_1.png](images/img_1.png)
Select image
![img_2.png](images/img_2.png)
Fill other parameters as needed, then click Buy Now
![img_3.png](images/img_3.png)

> **Note:**
- You can create VPC yourself
- Select security group configured in [Preparations](#preparations)
- For Elastic IP, choose "Pay-by-traffic" (recommended), set bandwidth to 5Mbit/s
- Advanced configuration requires custom data injection, so don't select "Password" for credentials (set after creation)
- Keep other settings default or follow guidelines

## Product Usage
### Check Dify Processes
- After login, run `docker ps` to view Dify processes:
![alt text](./images/image-2.png)

- Access Dify platform via browser:
Initial login URL: http://your_ip/install
![alt text](./images/image-3.png)

### Configure DeepSeek-R1 Inference Service
- Check service status with `systemctl status ollama` (ensure it's running)
Model name: deepseek-r1:7b-qwen-distill-q8_0
![alt text](./images/image-4.png)

### Complete Dify Documentation
[Dify Documentation](https://docs.dify.ai/zh-hans/development/models-integration/ollama)
