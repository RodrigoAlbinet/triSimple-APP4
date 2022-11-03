import 'dart:convert';

import 'package:app_4/models/event_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/database/equipamento.dart';
import '../models/database/evento.dart';

//AS SERVICE

class DatabaseService {
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  final _baseAPI = 'http://dev.trisimple.pt';
  Future<List<Equipamento>?> readEquips() async {
    try {
      List<Equipamento> equipamentos = List.empty(growable: true);

      final result = await http.get(Uri.parse('$_baseAPI/equipamentos'));
      print(result.body);
      final List<dynamic> resultJson = json.decode(result.body);
      for (var equipJson in resultJson) {
        print('EQUIPAMENTO: \n $equipJson');
        final estadoEquip =
            await _getEstadoEquip(equipJson['id_estado'] as int);
        print('222');
        final tipoEquip = await _getTipoEquip(equipJson['id_tipo']);
        print('3333');

        equipamentos.add(Equipamento(
            id: equipJson['id'],
            numeroEquipamento: equipJson['numero_equipamento'],
            tipoEquipamento: tipoEquip,
            estadoEquipamento: estadoEquip));
        print('444: $equipamentos');
      }
      print("adwadaw");
      return equipamentos;
    } catch (e) {
      print('readEquips: $e');
    }
  }

  Future<List<Evento>?> readEventos() async {
    try {
      List<Evento> eventos = List.empty(growable: true);

      final result = await http.get(Uri.parse('$_baseAPI/eventos'));
      print("Eventos: ${result.body}");
      final List<dynamic> resultJson = json.decode(result.body);

      for (var equipJson in resultJson) {
        eventos.add(Evento(id: equipJson['id'], nome: equipJson['nome']));
      }
      return eventos;
    } catch (e) {
      print('readEventos: $e');
    }
  }

  Future<String> _getEstadoEquip(int idEstado) async {
    final result = await http.get(Uri.parse('$_baseAPI/estado_equipamento'));
    //TODO Pass where paramter instead of using where in the list
    List<dynamic> estados = json.decode(result.body);
    final estadoJson =
        estados.singleWhere((element) => element['id'] == idEstado);
    return estadoJson['estado_equipamento'];
  }

  Future<String> _getTipoEquip(int idTipo) async {
    final result = await http.get(Uri.parse('$_baseAPI/tipo_equipamento'));
    //TODO Pass where paramter instead of using where in the list
    List<dynamic> estados = json.decode(result.body);
    final estadoJson =
        estados.singleWhere((element) => element['id'] == idTipo);
    return estadoJson['tipo_equipamento'];
  }
}

//AS PROVIDER
/*
@immutable
class DatabaseState {
  final Iterable<Equipamento>? equipamentos;
  final Iterable<Evento>? eventos;
  final Iterable<EventTag>? tags;

  const DatabaseState({this.equipamentos, this.eventos, this.tags});

  DatabaseState copyWith({
    Iterable<Equipamento>? equipamentos,
    Iterable<Evento>? eventos,
    Iterable<EventTag>? tags,
  }) {
    return DatabaseState(
      equipamentos: equipamentos ?? this.equipamentos,
      eventos: eventos ?? this.eventos,
      tags: tags ?? this.tags,
    );
  }
}

@immutable
class DatabaseNotifier extends StateNotifier<DatabaseState> {
  final _baseAPI = 'https://dev.trisimple.pt';
  DatabaseNotifier() : super(const DatabaseState());

  Future<void> readEquips() async {
    List<Equipamento> equipamentos = List.empty(growable: true);
    try {
      final result = await http.get(Uri.https('$_baseAPI/equipamentos'));
      final List<Map<String, dynamic>> resultJson = json.decode(result.body);
      resultJson.forEach((equipJson) async {
        final estadoEquip = await _getEstadoEquip(equipJson['id_estado']);
        final tipoEquip = await _getTipoEquip(equipJson['id_tipo']);

        equipamentos.add(Equipamento(
            id: equipJson['id'],
            numeroEquipamento: equipJson['numero_equipamento'],
            tipoEquipamento: tipoEquip,
            estadoEquipamento: estadoEquip));
      });
    } catch (e) {
      print(e);
    }
    state = state.copyWith(equipamentos: equipamentos);
  }

  Future<List<Evento>> readEventos() async {
    List<Evento> eventos = List.empty(growable: true);
    try {
      final result = await http.get(Uri.https('$_baseAPI/eventos'));
      final List<Map<String, dynamic>> resultJson = json.decode(result.body);

      resultJson.forEach((equipJson) async {
        eventos.add(Evento(id: equipJson['id'], nome: equipJson['nome']));
      });
    } catch (e) {
      print(e);
    }
    state = state.copyWith(eventos: eventos);
    return eventos;
  }

  Future<String> _getEstadoEquip(int idEstado) async {
    final result = await http.get(Uri.https('$_baseAPI/estado_equipamento'));
    //TODO Pass where paramter instead of using where in the list
    List<Map<String, dynamic>> estados = json.decode(result.body);
    final estadoJson =
        estados.singleWhere((element) => element['id'] == idEstado);
    return estadoJson['estado_equipamento'];
  }

  Future<String> _getTipoEquip(int idTipo) async {
    final result = await http.get(Uri.https('$_baseAPI/tipo_equipamento'));
    //TODO Pass where paramter instead of using where in the list
    List<Map<String, dynamic>> estados = json.decode(result.body);
    final estadoJson =
        estados.singleWhere((element) => element['id'] == idTipo);
    return estadoJson['tipo_equipamento'];
  }
}

final databaseProvider =
    StateNotifierProvider<DatabaseNotifier, DatabaseState>((ref) {
  return DatabaseNotifier();
});
*/