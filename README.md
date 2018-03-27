# Stress tests for _mqtt_ API

## Running

1. To build the sources you need to have the [Builder](https://github.com/electricimp/Builder) installed.

2. Clone the repository to your local disc and change to it:

```
git clone https://github.com/ElectricImp-CSE/MQTTStressTests.git
cd MQTTStressTests
```

3. Retrieve the Azure IoT Hub [connection string](https://github.com/electricimp/AzureIoTHub#device-connection-string).

4. Build the sources by running:

```
pleasebuild src/agent.nut -DIOT_HUB_CONNECTION_STRING "connection string obtained on the previous step" > out.agent.nut
```

5. Copy and paste the contents of `out.agent.nut` to the Agent window in the impCentral [IDE](https://impcentral.electricimp.com) and press `Build and Force Restart` button.

## Test Description

### [CreateClientTest](./src/tests/CreateClient.agent.test.nut)

Opens/closes _mqtt_ clients in a loop.

### [ConnectDisconnectTest](./src/tests/ConnectDisconnect.agent.test.nut)

Connects/disconnects the client in a loop.

### [Device2CloudTest](./src/tests/Device2Cloud.agent.test.nut)

Simple messaging test.

### [SubscribeTest](./src/tests/Subscribe.agent.test.nut)

Simple application test with subscriptions and cloud-to-device messages.


## License

The tests are licensed under the [MIT License](./LICENSE).