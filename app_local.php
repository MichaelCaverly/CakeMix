<?php
use Cake\Database\Connection;
use Cake\Database\Driver\Mysql;

return [

    'Datasources' => [
        'default' => [
            'className' => Connection::class,
            'driver' => Mysql::class,
            'persistent' => false,
            'timezone' => 'UTC',
            'host' => env('MYSQL_HOST', null),
            'port' => env('MYSQL_PORT', null),
            'username' => env('MYSQL_USERNAME', null),
            'password' => env('MYSQL_PASSWORD', null),
            'database' => env('MYSQL_DATABASE', null),
            'encoding' => 'utf8mb4',
            'flags' => [],
            'cacheMetadata' => false,
            'log' => false,
            'quoteIdentifiers' => true,
            'url' => env('DATABASE_URL', null),
        ],
    ],

];
