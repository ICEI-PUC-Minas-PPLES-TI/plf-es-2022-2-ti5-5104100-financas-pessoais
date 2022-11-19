using System.Text;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Interfaces.Sevices;
using Newtonsoft.Json;
using RabbitMQ.Client;
using WeBudgetWebAPI.DTOs.Response;
using WeBudgetWebAPI.Models.Enums;

namespace WeBudgetWebAPI.Services;

public class MenssageBrokerService<T>:IMessageBrokerService<T> where T : class
{
    public async Task<T> SendMenssage(MenssageResponse<T> mesageResponse)
    {
        // CloudAMQP URL in format amqp://user:pass@hostName:port/vhost
        var url = "amqps://mfkdedri:t87XD1FFJHT-Yow3qYnOb3GHqbKIPhyL@moose.rmq.cloudamqp.com/mfkdedri";

        // Create a ConnectionFactory and set the Uri to the CloudAMQP url
        // the connectionfactory is stateless and can safetly be a static resource in your app
        var factory = new ConnectionFactory
        {
            Uri = new Uri(url)
        };
        // create a connection and open a channel, dispose them when done
        using var connection = factory.CreateConnection();
        using var channel = connection.CreateModel();
        // ensure that the queue exists before we publish to it
        var queueName = "mqtt-subscription-"+ mesageResponse.UserId+"qos1";
        bool durable = true;
        bool exclusive = false;
        bool autoDelete = true;

        channel.QueueDeclare(queueName, durable, exclusive, autoDelete, null);
        
        // the data put on the queue must be a byte array
        var data = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(mesageResponse));
        // publish to the "default exchange", with the queue name as the routing key
        var exchangeName = "";
        var routingKey = queueName;
        channel.BasicPublish(exchangeName, routingKey, null, data);
        return mesageResponse.Object;

    }
    
    private async Task<T> SendMenssage(TableType table, OperationType operation,
        string userId, T Object)
    {
        return await SendMenssage(new MenssageResponse<T>()
        {
            Table = table,
            UserId = userId,
            Operation = operation,
            Object = Object
        });
    }
    
}