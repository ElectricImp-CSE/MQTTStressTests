// MIT License
//
// Copyright 2018 Electric Imp
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

class TestBase {

    client              = null;
    options             = null;
    device2cloud_url    = null;

    function shutdown(onComplete) {
        local gracefully = :: irand(100);

        if (gracefully) client.disconnect();

        client = null;

        print ("Test " + this + " closed");

        onComplete();
    }

    function _create(authToken) {
        print("Creating client");

        local cn = AzureIoTHub.ConnectionString.Parse(authToken);
        local devPath = "/" + cn.DeviceId;
        local resourcePath = "/devices" + devPath;
        local resourceUri = AzureIoTHub.Authorization.encodeUri(cn.HostName + resourcePath);

        local password  = AzureIoTHub.SharedAccessSignature.create(resourceUri, null, cn.SharedAccessKey, AzureIoTHub.Authorization.anHourFromNow()).toString();
        local username  = cn.HostName + devPath + "/" + AZURE_HTTP_API_VERSION;
        local url       = "ssl://" + cn.HostName;

        device2cloud_url = "devices/" + cn.DeviceId + "/messages/events/";
        options = {"username" : username, "password" : password};

        client = mqtt.createclient(url, cn.DeviceId, _onmessage.bindenv(this), _ondelivery.bindenv(this), _disconnected.bindenv(this));
    }

    function _connect() {
        print("Connecting");
        client.connect(_onconnected.bindenv(this), options);
    }

    function _onmessage(message) {
        print("_onmessage: " + this);
    }

    function _ondelivery(message) {
        print("_ondelivery: " + this);
    }

    function _disconnected() {
        print("_disconnected: " + this);
    }

    function _typeof() {
        return "TestBase";
    }
}
