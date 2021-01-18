<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Dashboard') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-xl sm:rounded-lg">
                <div class="p-6 sm:p-20 bg-white border-b border-gray-200">
                    <div class="text-2xl">
                        Welcome to webserver.management!
                    </div>

                    <div class="mt-6 text-gray-500">
                        Manage your server on the <a href="/server" class="underline hover:no-underline">server page</a> and the sites on it from the <a href="/sites" class="underline hover:no-underline">sites page</a>.
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
