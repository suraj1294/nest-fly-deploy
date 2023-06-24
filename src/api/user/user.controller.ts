import {
  Body,
  ClassSerializerInterceptor,
  Controller,
  Delete,
  Get,
  HttpException,
  HttpStatus,
  Inject,
  NotFoundException,
  Param,
  ParseIntPipe,
  Post,
  UseInterceptors,
} from '@nestjs/common';
import { CreateUserDto } from './user.dto';
import { User } from './user.entity';
import { UserService } from './user.service';

@Controller('users')
export class UserController {
  @Inject(UserService)
  private readonly service: UserService;

  @UseInterceptors(ClassSerializerInterceptor)
  @Get()
  async getUsers(): Promise<User[]> {
    return this.service.getUsers();
  }

  @UseInterceptors(ClassSerializerInterceptor)
  @Get(':id')
  async getUser(@Param('id', ParseIntPipe) id: number) {
    const user = await this.service.getUser(id);
    if (user === null) {
      throw new NotFoundException({
        status: HttpStatus.NOT_FOUND,
        error: 'User Not Found',
      });
    }
    return user;
  }

  @Post()
  async createUser(@Body() body: CreateUserDto): Promise<User> {
    return this.service.createUser(body);
  }

  @Delete(':id')
  async deleteUser(@Param('id', ParseIntPipe) id: number) {
    const deleteResult = await this.service.deleteUser(id);
    if (deleteResult.affected) {
      return {
        status: 'ok',
      };
    } else {
      throw new HttpException(
        {
          status: HttpStatus.NOT_FOUND,
          error: 'User Not Found',
        },
        HttpStatus.FORBIDDEN,
        {
          cause: new Error('User Not Found'),
        },
      );
    }
  }
}
