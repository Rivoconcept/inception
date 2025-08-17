# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/22 08:39:35 by rhanitra          #+#    #+#              #
#    Updated: 2024/03/22 08:40:09 by rhanitra         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#*****************VARIABLES****************************************

#CLIENT
MINI_CLIENT = mini_client.c

DIR_MINI_CLIENT = ./minitalk/
SRC_MINI_CLIENT= $(addprefix $(DIR_MINI_CLIENT),$(MINI_CLIENT))

#SERVER
MINI_SERVER = mini_server.c

DIR_MINI_SERVER = ./minitalk/
SRC_MINI_SERVER= $(addprefix $(DIR_MINI_SERVER),$(MINI_SERVER))

#PRINTF
DIR_FT_PRINTF = ./ft_printf
FT_PRINTF = $(DIR_FT_PRINTF)/libftprintf.a

#LIBFT
DIR_LIBFT = ./libft
LIBFT = $(DIR_LIBFT)/libft.a

SRC_CLIENT = $(SRC_MINI_CLIENT)
SRC_SERVER = $(SRC_MINI_SERVER)
OBJ_CLIENT = $(SRC_CLIENT:.c=.o)
OBJ_SERVER = $(SRC_SERVER:.c=.o)

#****************TARGET**********************************************
CLIENT = client
SERVER = server

#****************COMMAND**********************************************
CFLAGS = -Wall -Wextra -Werror -g -I $(DIR_FT_PRINTF) -I $(DIR_LIBFT)
CC = gcc
RM = rm -rf
AR = ar rcs

#*********************CODE********************************************

all : $(CLIENT) $(SERVER) 

%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $<

$(FT_PRINTF):
	$(MAKE) -C $(DIR_FT_PRINTF)

$(LIBFT):
	$(MAKE) -C $(DIR_LIBFT)

$(CLIENT) : $(OBJ_CLIENT) $(FT_PRINTF) $(LIBFT) 
	$(CC)  $(CFLAGS) -o $@ $^ -L$(DIR_FT_PRINTF) -lftprintf -L$(DIR_LIBFT) -lft

$(SERVER) : $(OBJ_SERVER) $(FT_PRINTF) $(LIBFT) 
	$(CC)  $(CFLAGS) -o $@ $^ -L$(DIR_FT_PRINTF) -lftprintf -L$(DIR_LIBFT) -lft

clean :
	$(RM) $(OBJ_CLIENT) $(OBJ_SERVER)
	$(MAKE) -C $(DIR_FT_PRINTF) clean
	$(MAKE) -C $(DIR_LIBFT) clean
	
fclean : clean
	$(RM) $(CLIENT) $(SERVER)
	$(MAKE) -C $(DIR_FT_PRINTF) fclean
	$(MAKE) -C $(DIR_LIBFT) fclean

re : fclean all

.PHONY: all clean fclean re
