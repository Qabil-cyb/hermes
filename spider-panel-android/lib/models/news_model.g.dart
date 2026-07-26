// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsItemAdapter extends TypeAdapter<NewsItem> {
  @override
  final int typeId = 5;

  @override
  NewsItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsItem(
      title: fields[0] as String,
      description: fields[1] as String?,
      imageUrl: fields[2] as String?,
      url: fields[3] as String,
      publishedAt: fields[4] as String?,
      fetchedAt: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NewsItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.publishedAt)
      ..writeByte(5)
      ..write(obj.fetchedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
