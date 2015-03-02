// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library toyapi;

import 'dart:io';

import 'package:rpc/rpc.dart';

class ToyResponse {
  String result;
  ToyResponse(this.result);
}

class ToyResourceResponse {
  String result;
  ToyResourceResponse(this.result);
}

class NestedResponse {
  String nestedResult;
  NestedResponse(this.nestedResult);
}

class ToyMapResponse {
  String result;
  Map<String, NestedResponse> mapResult;

  ToyMapResponse(this.result, this.mapResult);
}

class ToyRequest {
  @ApiProperty(required: true)
  String name;

  @ApiProperty(defaultValue: 1000)
  int age;
}

class ToyAgeRequest {
  @ApiProperty(defaultValue: 1000)
  int age;
}

@ApiClass(version: '0.1')
class ToyApi {

  ToyApi();

  @ApiResource()
  final ToyCompute compute = new ToyCompute();

  @ApiResource()
  final ToyStorage storage = new ToyStorage();

  @ApiMethod(path: 'noop')
  VoidMessage noop() { return null; }

  @ApiMethod(path: 'failing')
  VoidMessage failing() {
    throw new RpcError(HttpStatus.NOT_IMPLEMENTED, 'Not Implemented',
                       'I like to fail!');
  }

  @ApiMethod(path: 'hello')
  ToyResponse hello() { return new ToyResponse('Hello there!'); }

  @ApiMethod(path: 'helloReturnNull')
  ToyResponse helloReturnNull() { return null; }

  @ApiMethod(path: 'hello/{name}/age/{age}')
  ToyResponse helloNameAge(String name, int age) {
    return new ToyResponse('Hello ${name} of age ${age}!');
  }

  @ApiMethod(path: 'helloPost', method: 'POST')
  ToyResponse helloPost(ToyRequest request) {
    return new ToyResponse('Hello ${request.name} of age ${request.age}!');
  }

  @ApiMethod(path: 'helloVoid', method: 'POST')
  ToyResponse helloVoid(VoidMessage request) {
    return new ToyResponse('Hello Mr. Void!');
  }

  @ApiMethod(path: 'helloPost/{name}', method: 'POST')
  ToyResponse helloNamePostAge(String name, ToyAgeRequest request) {
    return new ToyResponse('Hello ${name} of age ${request.age}!');
  }

  @ApiMethod(path: 'helloNestedMap')
  ToyMapResponse helloNestedMap() {
    var map = {
      'bar': new NestedResponse('somethingNested'),
      'var': new NestedResponse('someotherNested')
    };
    return new ToyMapResponse('foo', map);
  }

  @ApiMethod(path: 'helloQuery/{name}')
  ToyResponse helloNameQueryAgeFoo(String name, {String foo, int age}) {
    return new ToyResponse('Hello $name of age $age with $foo!');
  }

  @ApiMethod(path: 'reverseList', method: 'POST')
  List<String> reverseList(List<String> request) {
    return request.reversed.toList();
  }

  @ApiMethod(path: 'helloMap', method: 'POST')
  Map<String, int> helloMap(Map<String, int> request) {
    request['hello'] = 42;
    return request;
  }

  @ApiMethod(path: 'helloNestedMapMap', method: 'POST')
  Map<String, Map<String, bool>> helloNestedMapMap(
      Map<String, Map<String, int>> request) {
    return null;
  }

  @ApiMethod(path: 'helloNestedListList', method: 'POST')
  List<List<String>> helloNestedListList(
      List<List<int>> request) {
    return null;
  }

  @ApiMethod(path: 'helloNestedMapListMap', method: 'POST')
  Map<String, List<Map<String, bool>>> helloNestedMapListMap(
      Map<String, List<Map<String, int>>> request) {
    return null;
  }

  @ApiMethod(path: 'helloNestedListMapList', method: 'POST')
  List<Map<String, List<String>>> helloNestedListMapList(
      List<Map<String, List<int>>> request) {
    return null;
  }

  @ApiMethod(path: 'helloListOfClass', method: 'POST')
  Map<String, ToyResponse> helloListOfClass (
      List<ToyRequest> request) {
    var key, value;
    if (request == null || request.isEmpty) {
      key = 'John Doe';
      value = 42;
    } else {
      key = request.first.name;
      value = request.first.age;
    }
    return {key: new ToyResponse(value.toString())};
  }

}

class ToyCompute {

  @ApiMethod(path: 'toyresource/{resource}/compute/{compute}')
  ToyResourceResponse get(String resource, String compute) {
    return new ToyResourceResponse('I am the compute: $compute of resource: '
                                   + resource);
  }
}

class ToyStorage {

  @ApiMethod(path: 'toyresource/{resource}/storage/{storage}')
  ToyResourceResponse get(String resource, String storage) {
    return new ToyResourceResponse('I am the storage: $storage of resource: '
                                   + resource);
  }
}

