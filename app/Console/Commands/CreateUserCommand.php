<?php

namespace App\Console\Commands;

use App\Actions\Fortify\CreateNewUser;
use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Str;

class CreateUserCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'user:create';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create the initial user';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        if (User::firstWhere('email', 'login@webserver.management')) {
            $this->error('There is already a user with email: login@webserver.management');
            return;
        }

        $password = Str::random(10);

        (new CreateNewUser)->create([
            'name' => 'User',
            'email' => 'login@webserver.management',
            'password' => $password,
            'password_confirmation' => $password
        ]);

        $this->line($password);
    }
}
