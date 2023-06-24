import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeleteResult, Repository } from 'typeorm';
import { CreateUserDto } from './user.dto';
import { User } from './user.entity';

@Injectable()
export class UserService {
  @InjectRepository(User)
  private readonly repository: Repository<User>;

  async getUser(id: number): Promise<User> {
    return this.repository.findOne({
      where: { id },
    });
  }

  async createUser(body: CreateUserDto): Promise<User> {
    const user: User = new User(body);

    return this.repository.save(user);
  }

  async getUsers(): Promise<User[]> {
    return this.repository.find();
  }

  async deleteUser(id: number): Promise<DeleteResult> {
    return this.repository.delete(id);
  }
}
