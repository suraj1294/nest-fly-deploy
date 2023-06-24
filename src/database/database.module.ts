import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      useFactory: (configServices: ConfigService) => ({
        type: 'postgres',
        host: configServices.getOrThrow('DATABASE_HOST'),
        database: configServices.getOrThrow('DATABASE_NAME'),
        username: configServices.getOrThrow('DATABASE_USER'),
        port: configServices.getOrThrow('DATABASE_PORT'),
        password: configServices.getOrThrow('DATABASE_PASSWORD'),
        autoLoadEntities: true,
        synchronize: configServices.getOrThrow('DATABASE_SYNCHRONIZE'),
      }),
      inject: [ConfigService],
    }),
  ],
})
export class DatabaseModule {}
