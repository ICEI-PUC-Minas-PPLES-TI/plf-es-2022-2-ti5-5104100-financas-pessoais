using Newtonsoft.Json;
using RabbitMQ.Client;
using System;
using System.Text;
using WeBudgetWebAPI.DTOs;
using WeBudgetWebAPI.Models;

namespace WeBudgetWebAPI.Services
{
    public class Publisher
    {
        // CloudAMQP URL in format amqp://user:pass@hostName:port/vhost
        private static readonly string url = "amqps://mfkdedri:t87XD1FFJHT-Yow3qYnOb3GHqbKIPhyL@moose.rmq.cloudamqp.com/mfkdedri";
        public static void publish()
        {
            // CloudAMQP URL in format amqp://user:pass@hostName:port/vhost
        

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
            var queueName = "mqtt-subscription-Natanielqos1";
            bool durable = true;
            bool exclusive = false;
            bool autoDelete = true;

            channel.QueueDeclare(queueName, durable, exclusive, autoDelete, null);

            // read message from input
            var salvarCategoria = new CategoryReponse(1, "C#", 123);
            var mensagem = JsonConvert.SerializeObject(salvarCategoria);

            mensagem = JsonConvert.SerializeObject(new Resposta<String>("Categoria", "Post", "1"));
            // the data put on the queue must be a byte array
            var data = Encoding.UTF8.GetBytes(mensagem);
            // publish to the "default exchange", with the queue name as the routing key
            var exchangeName = "";
            var routingKey = queueName;
            channel.BasicPublish(exchangeName, routingKey, null, data);

        }
}
}
