/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/04/02 12:06:39 by rhanitra          #+#    #+#             */
/*   Updated: 2024/04/06 17:23:49 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef FT_PRINTF_H
# define FT_PRINTF_H

# include <stdarg.h>
# include "../libft/libft.h"

int		ft_print_char(int input);
int		ft_print_int(int input);
int		ft_print_str(char *input);
int		ft_nbrlen(unsigned long n);
int		ft_printf(const char *input, ...);
int		ft_print_uint(unsigned int input, char const *base, int base_type);
int		ft_print_hexa(unsigned long input, char const *base, int base_type);
int		ft_print_pointer(unsigned long input, char const *base, int base_type);

#endif
